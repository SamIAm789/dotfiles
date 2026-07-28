{
  flake.modules.nixos.backup = {
    networking = {
      hostId = "3f0e3f27"; # needed for zfs
    };
  };
}
