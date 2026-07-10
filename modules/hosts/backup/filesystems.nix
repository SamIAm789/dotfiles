{
  flake.modules.nixos.backup = {

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
  };
}
