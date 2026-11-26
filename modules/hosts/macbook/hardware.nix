{
  flake.modules.nixos.macbook-hardware =
    {
      modulesPath,
      pkgs,
      ...
    }:
    let
      macbookWifiFirmware = pkgs.runCommand "macbookpro14-1-wifi-firmware" { } ''
        firmwareDir="$out/lib/firmware/brcm"
        mkdir -p "$firmwareDir"

        # BCM4350 NVRAM files
        install -m 0644 \
          "${./_hardware/firmware/wifi}/brcmfmac4350-pcie.txt" \
          "$firmwareDir/brcmfmac4350-pcie.txt"

        install -m 0644 \
          "${./_hardware/firmware/wifi}/brcmfmac4350-pcie-Apple-MacBookPro14,1.txt" \
          "$firmwareDir/brcmfmac4350-pcie.Apple Inc.-MacBookPro14,1.txt"

        # Compatibility names used by newer brcmfmac kernel drivers
        ln -s brcmfmac4350-pcie.txt \
          "$firmwareDir/brcmfmac4350c2-pcie.txt"

        ln -s "brcmfmac4350-pcie.Apple Inc.-MacBookPro14,1.txt" \
          "$firmwareDir/brcmfmac4350c2-pcie.Apple Inc.-MacBookPro14,1.txt"
      '';
    in
    {
      imports = [
        (modulesPath + "/hardware/network/broadcom-43xx.nix")
        (modulesPath + "/installer/scan/not-detected.nix")
      ];

      boot.initrd = {
        availableKernelModules = [
          "xhci_pci"
          "nvme"
          "usb_storage"
          "sd_mod"
        ];
        kernelModules = [ ];
      };

      boot.extraModulePackages = [ ];

      hardware.firmware = [
        macbookWifiFirmware
      ];
    };
}
