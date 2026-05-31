{
  flake.modules.nixos.server = {
    services.sanoid.datasets = {
      "stuff/photos" = {
        useTemplate = [ "production" ];
      };
    };
  };
}
