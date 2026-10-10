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
      isLighthouse = host == "lighthouse";
      lighthouseIP = "161.33.225.147:4242";

    in
    {

      environment.systemPackages = [ pkgs.nebula ];

      services.nebula.networks.pertaka = {

        staticHostMap = lib.mkIf (!isLighthouse) {
          "100.100.0.1" = [ lighthouseIP ];
        };

        lighthouses = lib.mkIf (!isLighthouse) [ "100.100.0.1" ];

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

        relays = lib.mkIf (!isLighthouse) [ "100.100.0.1" ];
      };

      users.users.nebula-pertaka = {
        isSystemUser = true;
        uid = 945;
        group = "nebula-pertaka";
      };

      users.groups.nebula-pertaka.gid = 945;

    };
}
