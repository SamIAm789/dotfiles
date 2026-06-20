{
  flake.modules.nixos.backup =
    let
      src = "backup@100.100.0.4:stuff/";
      tgt = "backup/";
    in

    {
      services.syncoid = {
        enable = true;
        sshKey = "/var/lib/syncoid/id_syncoid";
        interval = "11:00";
        commonArgs = [
          "--no-sync-snap"
        ];
        commands = {
          immich = {
            source = "${src}immich";
            target = "${tgt}immich";
            recursive = true;
          };
          ocis = {
            source = "${src}ocis";
            target = "${tgt}ocis";
            recursive = true;
          };
          paperless = {
            source = "${src}paperless";
            target = "${tgt}paperless";
            recursive = true;
          };
          photos = {
            source = "${src}photos";
            target = "${tgt}photos";
            recursive = true;
          };
        };
      };
    }

    # create user backup in source machine (10.25.0.24)

    # create ssh key for syncoid on source and add public key to target

    # setup zfs delegation permissions on source for user "backup"
    # zfs allow backup snapshot stuff/<dataset>
    # zfs allow backup send stuff/<dataset>
    # zfs allow backup hold stuff/<dataset>


  };
}
