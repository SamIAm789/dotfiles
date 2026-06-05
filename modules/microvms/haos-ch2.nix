{
  flake.modules.nixos.haos-ch =
    { config, pkgs, lib, ... }:

    let
      vmName = "haos";

      haosDir = "/persist/microvms/haos";
      diskPath = "${haosDir}/haos.qcow2";
      firmwarePath = "${haosDir}/CLOUDHV.fd";

      tapName = "vm-${vmName}";
      bridgeName = "microbr";
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
          + builtins.substring 8 2 hash;

      macAddress = mkMac vmName;

    in
    {
      #####################################################################
      # No networking hacks, no iproute2 in service
      #####################################################################
      systemd.network.enable = true;

      systemd.network.netdevs = {
        "20-${tapName}" = {
          netdevConfig = {
            Name = tapName;
            Kind = "tap";
          };
        };
      };

      systemd.network.networks = {
        "30-${tapName}" = {
          matchConfig.Name = tapName;

          networkConfig = {
            Bridge = bridgeName;
          };

          linkConfig.RequiredForOnline = "no";
        };
      };

      #####################################################################
      # VM runtime
      #####################################################################
      systemd.services."${vmName}-vm" = {
        description = "Home Assistant OS VM (Cloud Hypervisor)";
        wantedBy = [ "multi-user.target" ];

        after = [
          "systemd-networkd-wait-online.service"
        ];

        wants = [
          "systemd-networkd-wait-online.service"
        ];

        serviceConfig = {
          Type = "simple";
          Restart = "on-failure";
          RestartSec = "5s";

          ###################################################################
          # Fully declarative ExecStart (NO SHELL, NO PRE-STEPS)
          ###################################################################
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

          ###################################################################
          # Minimal required privileges (microvm-style)
          ###################################################################
          User = "root";
          Group = "root";

          PrivateDevices = false;
          DevicePolicy = "auto";

          DeviceAllow = [
            "/dev/kvm rw"
          ];

          AmbientCapabilities = [
            "CAP_NET_ADMIN"
            "CAP_SYS_ADMIN"
          ];

          CapabilityBoundingSet = [
            "CAP_NET_ADMIN"
            "CAP_SYS_ADMIN"
          ];

          NoNewPrivileges = false;
        };
      };
    };
}
