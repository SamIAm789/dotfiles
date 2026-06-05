{
  flake.modules.nixos.haos-ch =
    { config,
      pkgs,
      lib,
      ...
    }:
    let
      haosDir = "/persist/microvms/haos";
      diskPath = "${haosDir}/haos.qcow2";           # confirmed from your earlier run
      firmwarePath = "${haosDir}/CLOUDHV.fd";
      tapName = "vm-haos";
      macAddress = "52:54:00:12:34:56";
      socketPath = "/run/cloud-hypervisor-haos.sock";
    in
    {
      environment.systemPackages = with pkgs; [
        cloud-hypervisor
        iproute2
      ];

      boot.kernelModules = [ "kvm-intel" "kvm-amd" ];

      # Wrapper still useful for manual runs
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
            "+${pkgs.runtimeShell} -c 'ip link show ${tapName} >/dev/null 2>&1 || ip tuntap add dev ${tapName} mode tap user root'"
            "+${pkgs.iproute2}/bin/ip link set ${tapName} master microbr"
            "+${pkgs.iproute2}/bin/ip link set ${tapName} up"
          ];

          # Use direct Nix store path (bypasses wrapper issues)
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

          ExecStop =
            "${pkgs.iproute2}/bin/ip link delete ${tapName}";
          ExecStopPost =
            "${pkgs.coreutils}/bin/rm -f ${socketPath}";

          User = "root";
          AmbientCapabilities = [ "CAP_NET_ADMIN" "CAP_SYS_ADMIN" ];
          CapabilityBoundingSet = [ "CAP_NET_ADMIN" "CAP_SYS_ADMIN" ];
          DeviceAllow = [
            "/dev/kvm rw"
            "/dev/net/tun rw"
          ];
          PrivateDevices = false;
        };
      };
    };
}
