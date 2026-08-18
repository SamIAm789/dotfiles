{
  self,
  ...
}:
{
  flake.modules.nixos.backup =
    let
      src = "backup@100.100.0.4:";
      tgt = "backup/";
    in
    {
      config,
      ...
    }:
    {
      sops.secrets."syncoid" = {
        sopsFile = "${self}/secrets/ssh.yaml";
        owner = config.users.users.syncoid.name;
        group = config.users.users.syncoid.group;
        mode = "0400";
      };

      systemd.tmpfiles.rules = [
        "d /mnt/backup 0755 root root -"
      ];

      preservation.preserveAt."/persist".users.syncoid.directories = [
        { directory = ".ssh"; mode = "0700"; }
      ];

      services.syncoid = {
        enable = true;
        sshKey = config.sops.secrets."syncoid".path;
        interval = "11:00";
        commonArgs = [
          "--no-sync-snap"
          "--compress=zstd-fast"
        ];
        service.serviceConfig = {
          BindReadOnlyPaths = [
            "/persist/userborn"
          ];
        };
        commands = {
          haos = {
            source = "${src}stuff/haos";
            target = "${tgt}haos";
            recursive = true;
          };
          opencloud = {
            source = "${src}stuff/opencloud";
            target = "${tgt}opencloud";
            recursive = true;
          };
          paperless = {
            source = "${src}stuff/paperless";
            target = "${tgt}paperless";
            recursive = true;
          };
          photos = {
            source = "${src}stuff/photos";
            target = "${tgt}photos";
            recursive = true;
          };
          haos-vm = {
            source = "${src}vmstore/haos";
            target = "${tgt}haos-vm";
          };
          immich = {
            source = "${src}vmstore/immich";
            target = "${tgt}immich-vm";
          };
        };
      };
    };

    # create user backup in source machine (10.25.0.24)

    # create ssh key for syncoid on source and add public key to target

    # setup zfs delegation permissions on source for user "backup"
    # zfs allow bacSkup snapshot stuff/<dataset>
    # zfs allow backup send stuff/<dataset>
    # zfs allow backup hold stuff/<dataset>

}
