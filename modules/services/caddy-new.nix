{
  flake.modules.nixos.caddy =
  { 
    config,
    lib,
    pkgs, 
    ... 
  }:
  let
    domain = "samiam-infra.duckdns.org"
  in
  {
    services.caddy = {
      enable = true;

      package = pkgs.caddy.withPlugins {
        plugins = [
        "github.com/caddy-dns/duckdns@v0.5.0"
        ];
        hash = lib.fakeHash;
      };

      openFirewall = true;

      virtualHosts."*.samiam-infra.duckdns.org".extraConfig = ''
        tls {
          dns duckdns {env.DUCKDNS_API_TOKEN}
        }

        @ha host ha.samiam-infra.duckdns.org
        reverse_proxy @ha 10.25.0.31:8123

        @jellyfin host jellyfin.samiam-infra.duckdns.org
        reverse_proxy @jellyfin 127.0.0.1:8096
      '';
    };

    sops.templates."caddy.env" = {
      content = ''
        DUCKDNS_API_TOKEN=${config.sops.placeholder."duckdns-token"}
      '';
      restartUnits = [ "caddy.service" ];
    };

    services.caddy.environmentFile =
    config.sops.templates."caddy.env".path;
  };
}