{
  flake.modules.nixos.nebula2 =
    {
      config,
      lib,
      pkgs,
      ...
    }:

    let
      host = config.networking.hostName;

      # Treat both machines as lighthouses
      lighthouseHosts = [ "oracle" "google" ];
      isLighthouse = lib.elem host lighthouseHosts;

      # Nebula overlay IPs of the lighthouses (adjust to your actual cert IPs)
      # Example assuming:
      #   oracle → 100.100.0.1
      #   google → 100.100.0.2
      lighthouseNebulaIPs = [ "100.100.0.1" "100.100.0.2" ];

      # Public endpoints (host:port) for static_host_map
      # Replace with the real public IPs / DNS names of oracle and google
      lighthousePublicEndpoints = {
        "100.100.0.1" = [ "PUBLIC_IP_OR_DNS_OF_ORACLE:4242" ];
        "100.100.0.2" = [ "PUBLIC_IP_OR_DNS_OF_GOOGLE:4242" ];
      };

    in
    {
      environment.systemPackages = [ pkgs.nebula ];

      services.nebula.networks.pertaka = {
        # Only non-lighthouses need the static map and lighthouse list
        staticHostMap = lib.mkIf (!isLighthouse) lighthousePublicEndpoints;

        lighthouses = lib.mkIf (!isLighthouse) lighthouseNebulaIPs;

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

        # Optional: also treat them as relays (same pattern)
        relays = lib.mkIf (!isLighthouse) lighthouseNebulaIPs;
      };

      users.users.nebula-pertaka = {
        isSystemUser = true;
        uid = 945;
        group = "nebula-pertaka";
      };

      users.groups.nebula-pertaka.gid = 945;
    };
}