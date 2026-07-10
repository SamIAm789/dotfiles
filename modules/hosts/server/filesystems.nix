{
  flake.modules.nixos.server-filesystems = {

    fileSystems."/" = {
      device = "rpool/local/root";
      fsType = "zfs";
    };

    fileSystems."/nix" = {
      device = "rpool/local/nix";
      fsType = "zfs";
    };

    fileSystems."/home" = {
      device = "rpool/local/home";
      fsType = "zfs";
    };

    fileSystems."/persist" = {
      device = "rpool/local/persist";
      fsType = "zfs";
      neededForBoot = true;
    };

    fileSystems."/stuff" = {
      device = "stuff";
      fsType = "zfs";
    };

    fileSystems."/stuff/haos" = {
      device = "stuff/haos";
      fsType = "zfs";
    };

    fileSystems."/stuff/home-vids" = {
      device = "stuff/home-vids";
      fsType = "zfs";
    };

    fileSystems."/stuff/immich" = {
      device = "stuff/immich";
      fsType = "zfs";
    };

    fileSystems."/stuff/immich-test" = {
      device = "stuff/immich-test";
      fsType = "zfs";
    };

    fileSystems."/stuff/incus-backups" = {
      device = "stuff/incus-backups";
      fsType = "zfs";
    };

    fileSystems."/stuff/ocis" = {
      device = "stuff/ocis";
      fsType = "zfs";
    };

    fileSystems."/stuff/opencloud" = {
      device = "stuff/opencloud";
      fsType = "zfs";
    };

    fileSystems."/stuff/paperless" = {
      device = "stuff/paperless";
      fsType = "zfs";
    };

    fileSystems."/stuff/photos" = {
      device = "stuff/photos";
      fsType = "zfs";
    };

    fileSystems."/stuff/pinchflat" = {
      device = "stuff/pinchflat";
      fsType = "zfs";
    };

    fileSystems."/stuff/rochelle" = {
      device = "stuff/rochelle";
      fsType = "zfs";
    };

    fileSystems."/stuff/videos" = {
      device = "stuff/videos";
      fsType = "zfs";
    };
  };
}
