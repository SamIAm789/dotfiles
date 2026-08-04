{
  flake.modules.nixos.backup = {
    boot.zfs.extraPools = [ "backup" ];
    boot.zfs.devNodes   = "/dev/disk/by-path";
  };
}
