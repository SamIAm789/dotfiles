{
  flake.nodules.nixos.backup = {
    boot.zfs.extraPools = [ "backup" ];
  };
}
