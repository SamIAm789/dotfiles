{ config, lib, pkgs, modulesPath, ... }:

{
  boot.initrd.availableKernelModules = [
    "virtio_scsi"
    "sd_mod"
  ];

  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/d63641a2-a408-41b6-be67-a7c21dd89881";
    fsType = "ext4";
  };

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/76D9-72C5";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}