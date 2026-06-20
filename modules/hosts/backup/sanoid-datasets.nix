{
  flake.modules.nixos.backup = {
    services.sanoid.datasets = {

      "backup/immich" = {
        useTemplate = [ "backup" ];
      };
      "backup/ocis" = {
        useTemplate = [ "backup" ];
      };
      "backup/paperless" = {
        useTemplate = [ "backup" ];
      };
      "backup/photos" = {
        useTemplate = [ "backup" ];
      };
    };
  };
}
