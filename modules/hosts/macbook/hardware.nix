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

  };
}
