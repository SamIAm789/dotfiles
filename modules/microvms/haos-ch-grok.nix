{
  flake.modules.nixos.haos-ch =
    { config,
      pkgs,
      lib,
      ...
    }:
    let
      # === Easy to override paths ===
      haosDir = "/persist/microvms/haos";
      diskPath = "${haosDir}/haos.qcow2";
      firmwarePath = "${haosDir}/CLOUDHV.fd";

      tapName = "vm-haos";
      macAddress = "02:54:00:12:34:56";
    in
    {
      environment.systemPackages = with pkgs; [
        cloud-hypervisor
        iproute2
      ];

      # Allow cloud-hypervisor to manage TAP interfaces
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
          RestartSec = "5s";

          # Setup TAP interface (auto-attaches to microbr thanks to your network config)
          ExecStartPre = [
            "${pkgs.iproute2}/bin/ip tuntap add dev ${tapName} mode tap user root"
            "${pkgs.iproute2}/bin/ip link set ${tapName} master microbr"
            "${pkgs.iproute2}/bin/ip link set ${tapName} up"
          ];

          ExecStart = ''
            ${config.security.wrappers.cloud-hypervisor.path} \
            --firmware ${firmwarePath} \
            --disk path=${diskPath},format=qcow2 \
            --cpus boot=2 \
            --memory size=4G \
            --console tty \
            --serial tty \
            --net "tap=${tapName},mac=${macAddress}" \
            --api-socket /run/cloud-hypervisor-haos.sock
          '';

          ExecStop = "${pkgs.iproute2}/bin/ip link delete ${tapName} || true";

          User = "root";
          AmbientCapabilities = "CAP_NET_ADMIN";
          CapabilityBoundingSet = "CAP_NET_ADMIN";
        };
      };
    };
}
