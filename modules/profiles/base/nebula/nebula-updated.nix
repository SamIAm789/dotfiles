{
  flake.modules.nixos.nebula =
    {
      config,
      lib,
      pkgs,
      ...
    }:

    let
      host = config.networking.hostName;

      lighthouseHosts = [
        "oracle"
      ];

      isLighthouse = lib.elem host lighthouseHosts;

      lighthouseNebulaIPs = [
        "100.100.0.1" #oracle
        "100.100.0.2" #google
        "100.100.0.3" #oracle-nixos
      ];

      lighthousePublicEndpoints = {
        "100.100.0.1" = [ "161.33.225.147:4242" ];
        "100.100.0.2" = [ "35.209.173.73:4242" ];
        "100.100.0.3" = [ "161.33.231.180:4242" ];
      };

    in
    {
      environment.systemPackages = [ pkgs.nebula ];

      services.nebula.networks.pertaka = {
        listen.port = 4242;
        # Only non-lighthouses need the static map and lighthouse list
        staticHostMap = lib.mkIf (!isLighthouse) lighthousePublicEndpoints;

        lighthouses = lib.mkIf (!isLighthouse) lighthouseNebulaIPs;

        isRelay = isLighthouse;

        relays = lib.mkIf (!isLighthouse) lighthouseNebulaIPs;

        settings = {
          lighthouse = {
            am_lighthouse = isLighthouse;
            interval = 60;
          };

          punchy = {
            punch = true;
            respond = true;
          };
        };

        firewall = {
          outbound = [
            { host = "any"; port = "any"; proto = "any"; }
          ];
          inbound = [
            { host = "any"; port = "any"; proto = "any"; }
          ];
        };
      };

      users.users.nebula-pertaka = {
        isSystemUser = true;
        uid = 945;
        group = "nebula-pertaka";
      };

      users.groups.nebula-pertaka.gid = 945;
    };
}
