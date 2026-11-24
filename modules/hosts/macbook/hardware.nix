{
  flake.modules.nixos.macbook-hardware =
  {
    modulesPath,
    ...
  }:
  {

    imports = [
      (modulesPath + "/hardware/network/broadcom-43xx.nix")
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

    boot.initrd = {
      availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" ];
      kernelModules = [ ];
    };
    boot.extraModulePackages = [ ];

    fileSystems."/" =
      { device = "/dev/disk/by-uuid/24d9092b-dd3a-43fa-bf1f-58e703d996af";
        fsType = "ext4;";
      };
    fileSystems."/boot" =
      { device = "/dev/disk/by-uuid/277A-A609";
        fsType = "vfat";
      };
    swapDevices =
      [ { device = "/dev/disk/by-uuid/135e3b6a-7a90-4977-9cca-6002bbb53bfa"; }
      ];

  };
}
