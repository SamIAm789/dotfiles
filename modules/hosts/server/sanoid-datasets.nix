{
  flake.modules.nixos.server = {
    services.sanoid.datasets = {
      "stuff/photos" = {
        useTemplate = [ "production" ];
      };
      "vmstore/haos" = {
        use template = [ "productions ];
      };
    };
  };
}
