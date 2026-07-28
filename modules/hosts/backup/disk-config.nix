{
  inputs,
  ...
}:
{
  flake.modules.nixos.backup = {

    imports = [ inputs.disko.nixosModules.disko ];

    disko.devices = {
      disk = {
        root = {
          type = "disk";
          device = "/dev/disk/by-id/nvme-SK_hynix_BC501_HFM256GDJTNG-8310A_CY9AN03411030AJ58";
          content = {
            type = "gpt";
            partitions = {
              ESP = {
                size = "1G";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = [ "umask=0077" ];
                };
              };
              swap = {
                size = "4G";
                content = {
                  type = "swap";
                };
              };
              zfs = {
                size = "100%";
                content = {
                  type = "zfs";
                  pool = "rpool";
                };
              };
            };
          };
        };
        vmstore = {
          type = "disk";
          device = "/dev/disk/by-id/ata-Samsung_SSD_850_EVO_120GB_S21SNWAG601175N";
          content = {
            type = "gpt";
            partitions = {
              zfs = {
                size = "100%";
                content = {
                  type = "zfs";
                  pool = "vmstore";
                };
              };
            };
          };
        };
      };
      zpool = {
        rpool = {
          type = "zpool";
          rootFsOptions = {
            # https://wiki.archlinux.org/title/Install_Arch_Linux_on_ZFS
            acltype = "posixacl";
            atime = "off";
            compression = "zstd";
            mountpoint = "none";
            xattr = "sa";
          };
          options.ashift = "12";

          datasets = {
            "local" = {
              type = "zfs_fs";
              options.mountpoint = "none";
            };
            "local/home" = {
              type = "zfs_fs";
              mountpoint = "/home";
              # Used by services.zfs.autoSnapshot options.
              options."com.sun:auto-snapshot" = "false";
            };
            "local/nix" = {
              type = "zfs_fs";
              mountpoint = "/nix";
              options."com.sun:auto-snapshot" = "false";
            };
            "local/persist" = {
              type = "zfs_fs";
              mountpoint = "/persist";
              options."com.sun:auto-snapshot" = "false";
            };
            "local/root" = {
              type = "zfs_fs";
              mountpoint = "/";
              options."com.sun:auto-snapshot" = "false";
              postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^rpool/local/root@blank$' || zfs snapshot rpool/local/root@blank";
            };
            "local/safe/containers" = {
              type = "zfs_fs";
              mountpoint = "/persist/containers";
              options."com.sun:auto-snapshot" = "true";
            };
          };
        };
        vmstore = {
          type = "zpool";
          rootFsOptions = {
            acltype = "posixacl";
            atime = "off";
            compression = "zstd";
            xattr = "sa";
            mountpoint = "none";
            recordsize = "64k"; # https://klarasystems.com/articles/zfs-virtualization-storage-backend-for-pros/
          };
          options.ashift = "12";

          datasets = {
            "microvms" = {
              type = "zfs_fs";
              mountpoint = "/persist/microvms";
            };
          };
        };
      };
    };
  };
}
