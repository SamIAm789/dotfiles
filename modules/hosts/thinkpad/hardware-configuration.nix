{
  flake.modules.nixos.thinkpad =
  {
    config,
    lib,
    pkgs,
    modulesPath,
    ...
  }:
  {
    imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

    boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "sdhci_pci" ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ "kvm-intel" ];
    boot.extraModulePackages = [ ];

    fileSystems."/" =
    { device = "/dev/disk/by-uuid/eb2c0913-9d2d-4b79-a7ea-06bd86720ebd";
      fsType = "ext4";
    };

    fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/8414-537E";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

    swapDevices =
    [ { device = "/dev/disk/by-uuid/62bdd25f-42d5-44d0-b399-5c342d3d80c6"; }
    ];

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
