{
  flake.modules.nixos.immich-host =
  {
    config,
    ...
  }:
  {

    services.caddy.virtualHosts."immich.${config.constants.domain}".extraConfig =       ''
      reverse_proxy 127.0.0.1:2284
    '';
  };
}