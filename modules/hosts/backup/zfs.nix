{
  flake.modules.nixos.backup = {
    boot.zfs.extraPools = [ "backup" ];
  };
}
