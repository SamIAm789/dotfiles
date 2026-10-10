{
  flake.modules.nixos.google =
  { 
    config,
    lib,
    pkgs, 
    modulesPath,
    ... 
  }:
  {
    boot.initrd.availableKernelModules = [
      "virtio_scsi"
      "sd_mod"
    ];

    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ ];
    boot.extraModulePackages = [ ];

    swapDevices = [ ];

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  };
}