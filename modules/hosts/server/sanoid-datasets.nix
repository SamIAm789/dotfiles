{
  flake.modules.nixos.server = {
    services.sanoid.datasets = {
      "stuff/photos" = {
        useTemplate = [ "production" ];
      };
      "vmstore/haos" = {
        useTemplate = [ "production" ];
      };
      "vmstore/haos/data" = {
        useTemplate = [ "production" ];
      };
    };
  };
}
