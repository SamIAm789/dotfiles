{
  flake.modules.nixos.haos-ch =
    { config,
      pkgs,
      lib,
      ...
    }:
    let
      haosDir = "/persist/microvms/haos";
      diskPath = "${haosDir}/haos.qcow2";   # ← Confirm this filename!
      firmwarePath = "${haosDir}/CLOUDHV.fd";
      tapName = "vm-haos";
      macAddress = "52:54:00:12:34:56";
      chv = "/run/wrappers/bin/cloud-hypervisor";
      socketPath = "/run/cloud-hypervisor-haos.sock";
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

          # Only mkdir here — we'll create TAP manually for now
          ExecStartPre = [
            "${pkgs.coreutils}/bin/mkdir -p ${haosDir}"
          ];

          ExecStart = "${chv} --firmware ${firmwarePath} --disk path=${diskPath},image_type=qcow2 --cpus boot=2 --memory size=4G --console tty --serial tty --net \"tap=${tapName},mac=${macAddress}\" --api-socket ${socketPath}";

          ExecStop = ''
            ${pkgs.iproute2}/bin/ip link delete ${tapName} || true
            ${pkgs.coreutils}/bin/rm -f ${socketPath}
          '';

          User = "root";
          AmbientCapabilities = [ "CAP_NET_ADMIN" "CAP_SYS_ADMIN" ];
          CapabilityBoundingSet = [ "CAP_NET_ADMIN" "CAP_SYS_ADMIN" ];
          DeviceAllow = [ "/dev/kvm rw" ];
          PrivateDevices = false;
        };
      };
    };
}
