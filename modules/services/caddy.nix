{
  flake.modules.nixos.caddy = { pkgs, ... }: {

    services.caddy = {
      enable = true;

      package = pkgs.caddy.withPlugins (p: [
        p.caddy-dns-duckdns
      ]);

      environment = {
        DUCKDNS_TOKEN = "your-token"; # encrypt this with sops-nix
      };

      virtualHosts."pertaka.duckdns.org".extraConfig = ''
          tls {
            dns duckdns {env.DUCKDNS_TOKEN}
          }

          handle_path /homeassistant* {
            reverse_proxy http://localhost:8123
          }

          handle_path /grafana* {
            reverse_proxy http://localhost:3000
          }

          handle_path /n8n* {
            reverse_proxy http://localhost:5678
          }
        '';
      };
    };

    # add this to the lighthouse to make this work
    # lighthouse:
    #  serve_dns: true
    #  dns:
    #    host: "100.100.0.1"
    #    port: 53
    # static_host_map:
    #  "pertaka.duckdns.org": ["100.100.0.10"]
}
