{
  flake.modules.nixos.haos-ch =
    { config, pkgs, lib, ... }:

    let
      vmName = "haos";

      haosDir = "/persist/microvms/haos";
      diskPath = "${haosDir}/haos.qcow2";
      firmwarePath = "${haosDir}/CLOUDHV.fd";
      dataShareDir = "/persist/microvms/haos/data";
      virtiofsSocket = "/run/virtiofs-${vmName}-data.sock";
      fsTag = "ha-data";
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

      # download cloud-hypervisor firmware
      # wget https://github.com/cloud-hypervisor/edk2/releases/latest/download/CLOUDHV.fd

      # to migrate to another server
      # zfs snapshot -r pool/persist/microvms/haos@send1
      # zfs send -R pool/persist/microvms/haos@send1 | ssh user@newhost zfs recv -F pool/persist/microvms/haos

    in
    {

      environment.systemPackages = [ pkgs.virtiofsd ];

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

      systemd.services."virtiofsd-${vmName}-data" = {
    description = "virtiofsd for ${vmName} data share";
    wantedBy = [ "multi-user.target" ];
    before = [ "${vmName}-vm.service" ];

    serviceConfig = {
      Type = "notify";  # or "simple" if notify doesn't work
      ExecStart = "\( {pkgs.virtiofsd}/bin/virtiofsd --socket-path= \){virtiofsSocket} --shared-dir=${dataShareDir} --cache=never --thread-pool-size=4";
      
      # Fix PID file issue
      RuntimeDirectory = "virtiofsd-${vmName}";   # creates /run/virtiofsd-haos writable
      RuntimeDirectoryPreserve = "yes";
      
      ExecStop = "${pkgs.coreutils}/bin/rm -f ${virtiofsSocket}";
      Restart = "on-failure";
      
      User = "root";
      AmbientCapabilities = [ "CAP_SYS_ADMIN" ];
      CapabilityBoundingSet = [ "CAP_SYS_ADMIN" ];
      
      ReadWritePaths = [ dataShareDir ];
      ProtectSystem = "strict";
      ProtectHome = "read-only";  # optional tightening
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

          ExecStart = lib.concatStringsSep " " [
            "${pkgs.cloud-hypervisor}/bin/cloud-hypervisor"

            "--firmware" firmwarePath

            "--disk" "path=${diskPath},image_type=qcow2"

            "--cpus" "boot=2"

            "--memory" "size=4G,shared=on"

            "--console" "tty"

            "--serial" "tty"

            "--net" "tap=${tapName},mac=${macAddress}"
            
            "--fs" "tag=\( {fsTag},socket= \){virtiofsSocket},num_queues=4"


            "--api-socket" socketPath
          ];

          ExecStop = "${pkgs.coreutils}/bin/true";

          ExecStopPost =
            "${pkgs.coreutils}/bin/rm -f ${socketPath}";


          User = "root";
          Group = "root";

          PrivateDevices = false;
          DevicePolicy = "auto";

          DeviceAllow = [
            "/dev/kvm rw"
            "/dev/net/tun rw"
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
