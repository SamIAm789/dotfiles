{
  flake.modules.nixos.haos-ch =
    { config, pkgs, lib, ... }:

    let
      vmName = "haos";

      haosDir = "/persist/microvms/haos";
      diskPath = "${haosDir}/haos.qcow2";
      firmwarePath = "${haosDir}/CLOUDHV.fd";

      tapName = "vm-${vmName}";
      bridgeName = "microbr"; # assumes host already defines this

      socketPath = "/run/cloud-hypervisor-${vmName}.sock";

      mkMac = name:
        let
          hash = builtins.hashString "sha256" name;
        in
          "02:"
          + builtins.substring 0 2 hash + ":"
          + builtins.substring 2 2 hash + ":"
          + builtins.substring 4 2 hash + ":"
          + builtins.substring 6 2 hash + ":"
          + builtins.substring 8 2 hash + ":";

      macAddress = mkMac vmName;

    in
    {
      ####################################################################
      # VM runtime tools only
      ####################################################################
      environment.systemPackages = with pkgs; [
        cloud-hypervisor
      ];

      boot.kernelModules = [ "kvm-intel" "kvm-amd" ];

      ####################################################################
      # systemd-networkd: VM-side only
      ####################################################################
      systemd.network.enable = true;

      systemd.network.netdevs = {

        # TAP device owned by systemd-networkd (no iproute2 needed)
        "20-${tapName}" = {
          netdevConfig = {
            Name = tapName;
            Kind = "tap";
          };
        };
      };

      systemd.network.networks = {

        # Attach TAP to existing host bridge (microbr)
        "30-${tapName}" = {
          matchConfig.Name = tapName;

          networkConfig = {
            Bridge = bridgeName;
          };

          # VM networking does NOT affect host online state
          linkConfig.RequiredForOnline = "no";
        };
      };

      ####################################################################
      # VM service (no networking logic inside)
      ####################################################################
      systemd.services."${vmName}-vm" = {
        description = "Home Assistant OS VM (Cloud Hypervisor)";

        wantedBy = [ "multi-user.target" ];

        after = [
          "network-online.target"
          "systemd-networkd.service"
        ];

        wants = [ "network-online.target" ];

        serviceConfig = {
          Type = "simple";
          Restart = "on-failure";
          RestartSec = "5s";

          ExecStart = lib.concatStringsSep " " [
            "${pkgs.cloud-hypervisor}/bin/cloud-hypervisor"

            "--firmware" firmwarePath
            "--disk" "path=${diskPath},image_type=qcow2"

            "--cpus" "boot=2"
            "--memory" "size=4G"

            "--console" "tty"
            "--serial" "tty"

            "--net" "tap=${tapName},mac=${macAddress}"

            "--api-socket" socketPath
          ];

          ExecStop = "${pkgs.coreutils}/bin/true";

          ExecStopPost =
            "${pkgs.coreutils}/bin/rm -f ${socketPath}";

          User = "root";

          DeviceAllow = [
            "/dev/kvm rw"
          ];

          PrivateDevices = false;
        };
      };
    };
}
