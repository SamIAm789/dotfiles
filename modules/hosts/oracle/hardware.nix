
{
  flake.modules.nixos.oracle =
    {
      config,
      lib,
      pkgs,
      modulesPath,
      ...
    }:
    {
      imports = [
        (modulesPath + "/profiles/qemu-guest.nix")
      ];

      boot.loader.grub = {
        efiSupport = true;
        efiInstallAsRemovable = true;
        device = "nodev";
      };

      fileSystems."/boot/efi" = {
        device = "/dev/disk/by-uuid/349D-B205";
        fsType = "vfat";
      };

      fileSystems."/" = {
        device = "/dev/mapper/ocivolume-root";
        fsType = "xfs";
      };

      boot.initrd.availableKernelModules = [
        "ata_piix"
        "uhci_hcd"
        "xen_blkfront"
        "vmw_pvscsi"
      ];

      boot.initrd.kernelModules = [ "nvme" ];
      boot.kernelModules = [ ];
      boot.extraModulePackages = [ ];

      swapDevices = [ ];

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    };
}
