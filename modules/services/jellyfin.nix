{
  flake.modules.nixos.jellyfin =
  {
    config,
    ...
  }:
  {

    services.jellyfin = {
      enable = true;
      openFirewall = true;
    };
        services.caddy.virtualHosts."jellyfin.${config.constants.domain}".extraConfig =       ''
      reverse_proxy 127.0.0.1:8096
    '';
  };
}
