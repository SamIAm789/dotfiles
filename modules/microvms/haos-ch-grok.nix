{
  flake.modules.nixos.haos-ch-working =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      haosDir = "/persist/microvms/haos";
      diskPath = "${haosDir}/haos.qcow2";
      firmwarePath = "${haosDir}/CLOUDHV.fd";

      vmName = "haos";
      tapName = "vm-${vmName}";

      mkMac = vmName:
        let
          hash = builtins.hashString "sha256" vmName;
        in
          "02:"
          + builtins.substring 0 2 hash + ":"
          + builtins.substring 2 2 hash + ":"
          + builtins.substring 4 2 hash + ":"
          + builtins.substring 6 2 hash + ":"
          + builtins.substring 8 2 hash;

      macAddress = mkMac vmName;

      socketPath = "/run/cloud-hypervisor-${vmName}.sock";
    in
    {
      environment.systemPackages = with pkgs; [
        cloud-hypervisor
        iproute2
      ];

      boot.kernelModules = [ "kvm-intel" "kvm-amd" ];

      security.wrappers.cloud-hypervisor = {
        source = "${pkgs.cloud-hypervisor}/bin/cloud-hypervisor";
        capabilities = "cap_net_admin+ep";
        owner = "root";
        group = "root";
      };

      systemd.services.haos-vm = {
        description = "Home Assistant OS VM (Cloud Hypervisor)";
        wantedBy = [ "multi-user.target" ];
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];

        serviceConfig = {
          Type = "simple";
          Restart = "on-failure";
          RestartSec = "10s";

          ExecStartPre = [
            "${pkgs.coreutils}/bin/mkdir -p ${haosDir}"

            "+${pkgs.runtimeShell} -c '${pkgs.iproute2}/bin/ip link del ${tapName} 2>/dev/null || true'"

            "+${pkgs.runtimeShell} -c '${pkgs.iproute2}/bin/ip tuntap add dev ${tapName} mode tap user root'"

            "+${pkgs.runtimeShell} -c '${pkgs.iproute2}/bin/ip link set ${tapName} master microbr'"

            "+${pkgs.runtimeShell} -c '${pkgs.iproute2}/bin/ip link set ${tapName} up'"
          ];

          ExecStart = lib.concatStringsSep " " [
            "${pkgs.cloud-hypervisor}/bin/cloud-hypervisor"
            "--firmware"
            firmwarePath
            "--disk"
            "path=${diskPath},image_type=qcow2"
            "--cpus"
            "boot=2"
            "--memory"
            "size=4G"
            "--console"
            "tty"
            "--serial"
            "tty"
            "--net"
            "tap=${tapName},mac=${macAddress}"
            "--api-socket"
            socketPath
          ];

          ExecStop = "${pkgs.coreutils}/bin/true";

          ExecStopPost =
            "${pkgs.coreutils}/bin/rm -f ${socketPath}";

          User = "root";

          AmbientCapabilities = [
            "CAP_NET_ADMIN"
            "CAP_SYS_ADMIN"
          ];

          CapabilityBoundingSet = [
            "CAP_NET_ADMIN"
            "CAP_SYS_ADMIN"
          ];

          DeviceAllow = [
            "/dev/kvm rw"
            "/dev/net/tun rw"
          ];

          PrivateDevices = false;
        };
      };
    };
}
