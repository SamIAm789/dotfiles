{
  flake.modules.nixos.macbook-wifi =
  { lib, pkgs, ... }:
  let
    macbookWifiFirmware = pkgs.runCommand "macbookpro14-1-wifi-firmware" { } ''
      firmwareDir="$out/lib/firmware/brcm"
      mkdir -p "$firmwareDir"

      # NVRAM files
      install -m 0644 \
        "${./_hardware/firmware/wifi}/brcmfmac4350-pcie.txt" \
        "$firmwareDir/brcmfmac4350-pcie.txt"

      install -m 0644 \
        "${./_hardware/firmware/wifi}/brcmfmac4350-pcie-Apple-MacBookPro14,1.txt" \
        "$firmwareDir/brcmfmac4350-pcie.Apple Inc.-MacBookPro14,1.txt"

      # Names the driver looks for (c2 variant)
      ln -s brcmfmac4350-pcie.txt \
        "$firmwareDir/brcmfmac4350c2-pcie.txt"

      ln -s "brcmfmac4350-pcie.Apple Inc.-MacBookPro14,1.txt" \
        "$firmwareDir/brcmfmac4350c2-pcie.Apple Inc.-MacBookPro14,1.txt"
    '';
  in
  {
    boot.kernelParams = [
      "brcmfmac.feature_disable=0x82000"
    ];

    boot.extraModprobeConfig = ''
      options brcmfmac roamoff=1 feature_disable=0x82000
    '';

    networking.networkmanager = {
      wifi.powersave = false;
      wifi.backend = "iwd";
    };

    networking.wireless.enable = lib.mkForce false;

    # Make sure both the generic binary firmware and your NVRAM are available
    hardware.enableRedistributableFirmware = true;
    hardware.firmware = [
      pkgs.linux-firmware
      macbookWifiFirmware
    ];
  };
}