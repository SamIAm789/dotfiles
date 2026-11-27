{
  flake.modules.nixos.macbook-wifi =
  { lib, ... }:
  {
    boot.kernelParams = [
      "brcmfmac.feature_disable=0x82000"
    ];

    boot.extraModprobeConfig = ''
      options brcmfmac roamoff=1 feature_disable=0x82000
    '';

    networking.networkmanager = {
      wifi.powersave = false;
      wifi.backend = "iwd";          # forces iwd, disables wpa_supplicant
    };

    # Just to be extra sure (the backend option already does this)
    networking.wireless.enable = lib.mkForce false;

    macbookWifiFirmware = pkgs.runCommand "macbookpro14-1-wifi-firmware" { } ''
  firmwareDir="$out/lib/firmware/brcm"
  mkdir -p "$firmwareDir"

  # NVRAM
  install -m 0644 \
    "${./_hardware/firmware/wifi}/brcmfmac4350-pcie.txt" \
    "$firmwareDir/brcmfmac4350-pcie.txt"

  install -m 0644 \
    "${./_hardware/firmware/wifi}/brcmfmac4350-pcie-Apple-MacBookPro14,1.txt" \
    "$firmwareDir/brcmfmac4350-pcie.Apple Inc.-MacBookPro14,1.txt"

  # Compatibility names the driver looks for
  ln -s brcmfmac4350-pcie.txt \
    "$firmwareDir/brcmfmac4350c2-pcie.txt"

  ln -s "brcmfmac4350-pcie.Apple Inc.-MacBookPro14,1.txt" \
    "$firmwareDir/brcmfmac4350c2-pcie.Apple Inc.-MacBookPro14,1.txt"
'';
    hardware.enableRedistributableFirmware = true;
# or more specifically
hardware.firmware = [ pkgs.linux-firmware ];
  };
}