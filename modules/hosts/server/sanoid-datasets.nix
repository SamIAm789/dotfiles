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
      "vmstore/microvms/immich" = {
        useTemplate = [ "production" ];
      };
      "stuff/opencloud" = {
        useTemplate = [ "production" ];
      };
    };
  };
}
