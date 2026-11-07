{
  flake.modules.nixos.pinchflat =
  {
    config,
    pkgs,
    ...
  }:
  {

    services.pinchflat = {
      enable = true;
      package = pkgs.pinchflat-ngx;
      openFirewall = true;
      mediaDir = "/stuff/pinchflat";
      selfhosted = true;
    };
    services.caddy.virtualHosts."pinchflat.${config.constants.domain}".extraConfig =       ''
      reverse_proxy 127.0.0.1:8945
    '';
        
  };
}
