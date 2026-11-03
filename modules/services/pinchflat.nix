{
  flake.modules.nixos.pinchflat = {

    services.pinchflat = {
      enable = true;
      openFirewall = true;
      mediaDir = "/stuff/pinchflat";
      selfhosted = true;
    };
  };
}
