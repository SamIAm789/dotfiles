{
  flake.modules.nixos.pinchflat =
  {
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
  };
}
