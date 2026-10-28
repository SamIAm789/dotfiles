{
  flake.modules.nixos.preservation =
    {
      pkgs,
      ...
    }:
    {

      boot.initrd = {
        supportedFilesystems = [ "zfs" ];
      };

      # systemd in initrd requires a service instead of a command
      boot.initrd.systemd.services.rollback = {
        description = "rollback root filesystem";
        wantedBy = [ "initrd.target" ];
        after = [ "zfs-import-rpool.service" ];
        requires = [ "zfs-import-rpool.service" ];
        before = [ "sysroot.mount" ];
        path = with pkgs; [ zfs ];
        unitConfig.DefaultDependencies = "no";
        serviceConfig.Type = "oneshot";
        script = "zfs rollback -r rpool/local/root@blank";
      };
    };
}
