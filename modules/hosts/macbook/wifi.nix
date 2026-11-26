{
  flake.modules.nixos.macbook-wifi = {

    boot.kernelParams = [ "brcmfmac.feature_disable=0x82000" ];

    boot.extraModprobeConfig = ''
      options brcmfmac roamoff=1 feature_disable=0x82000
    '';

      networking.networkmanager.wifi.powersave = false;

    networking.networkmanager.wifi.backend = "iwd";
# (this automatically enables iwd and disables wpa_supplicant)
  };
}