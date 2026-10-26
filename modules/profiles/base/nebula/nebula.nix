{
  flake.modules.nixos.nebula =
    {
      config,
      pkgs,
      ...
    }:

    let
      host = config.networking.hostName;
      lighthouseEndpoints = {
        "100.100.0.1" = [ "161.33.225.147:4242" ];
        "100.100.0.2" = [ "35.209.173.73:4242" ];
      };
      lighthouseIPs = [
        "100.100.0.1"
        "100.100.0.2"
      ];

    in
    {

      environment.systemPackages = [ pkgs.nebula ];

      services.nebula.networks.pertaka = {

        staticHostMap =  lighthouseEndpoints;

        lighthouses = lighthouseIPs;

        settings = {
          lighthouse = {
            am_lighthouse = false;
            interval = 60;
          };

          punchy = {
            punch = true;
            respond = true;
          };
        };

        firewall = {
          outbound = [
            {
              host = "any";
              port = "any";
              proto = "any";
            }
          ];
          inbound = [
            { 
              host = "any"; 
              port = "any"; 
              proto = "any";
              local_cidr = "10.25.0.0/24";
            }
          ];
        };

        relays = lighthouseIPs;
      };

      users.users.nebula-pertaka = {
        isSystemUser = true;
        uid = 945;
        group = "nebula-pertaka";
      };

      users.groups.nebula-pertaka.gid = 945;

    };
}
