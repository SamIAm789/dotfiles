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
  };
}