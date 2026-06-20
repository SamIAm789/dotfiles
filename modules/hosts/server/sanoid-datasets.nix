{
  flake.modules.nixos.server = {
    services.sanoid.datasets = {
      "stuff/photos" = {
        useTemplate = [ "production" ];
      };
      "vmstore/haos" = {
        useTemplate = [ "production" ];
      };
      "stuff/haos" = {
        useTemplate = [ "production" ];
      };
    };
  };
}
