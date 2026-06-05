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
          + builtins.substring 8 2 hash;

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
      # VM service (no networking logic inside)
      ####################################################################
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

          ExecStartPre = [
            "${pkgs.coreutils}/bin/sleep 1"
            "${pkgs.runtimeShell} -c 'ip link show ${tapName} &>/dev/null && ip link delete ${tapName} || true'"
            "${pkgs.iproute2}/bin/ip tuntap add dev ${tapName} mode tap user root"
            "${pkgs.iproute2}/bin/ip link set ${tapName} master microbr"
            "${pkgs.iproute2}/bin/ip link set ${tapName} up"
          ];

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

          AmbientCapabilities = [
            "CAP_NET_ADMIN"
            "CAP_SYS_ADMIN"
          ];

          CapabilityBoundingSet = [
            "CAP_NET_ADMIN"
            "CAP_SYS_ADMIN"
          ];

          RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" "AF_NETLINK" ];

          DevicePolicy = "auto";
        };
      };
    };
}
