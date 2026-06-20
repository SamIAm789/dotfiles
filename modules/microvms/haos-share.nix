{
  flake.modules.nixos.haos-share =
  {
    pkgs,
    ...
  }:
  let
    vmName = "haos";
    dataShareDir = "/persist/microvms/haos/data";
    virtiofsSocket = "/run/virtiofs-${vmName}-data.sock";
    fsTag = "ha-data";
  in
  {
    environment.systemPackages = [ pkgs.virtiofsd ];

    systemd.services."virtiofsd-${vmName}-data" = {
      description = "virtiofsd for ${vmName} data share";
      wantedBy = [ "multi-user.target" ];
      before = [ "${vmName}-vm.service" ];

      serviceConfig = {
        Type = "notify";
        ExecStart = ''
          ${pkgs.virtiofsd}/bin/virtiofsd \
          --socket-path=${virtiofsSocket} \
          --shared-dir=${dataShareDir} \
          --cache=never \
          --thread-pool-size=4
          --sandbox none
        '';

        RuntimeDirectory = "virtiofsd-${vmName}";
        RuntimeDirectoryPreserve = "yes";

        ExecStop = "${pkgs.coreutils}/bin/rm -f ${virtiofsSocket}";
        Restart = "on-failure";

        User = "root";
        AmbientCapabilities = [ "CAP_SYS_ADMIN" ];
        CapabilityBoundingSet = [ "CAP_SYS_ADMIN" ];
        ReadWritePaths = [ dataShareDir ];
        ProtectSystem = "full";
        NoNewPrivileges = false;
        SecureBits = "keep-caps";
      };
    };
  };
}