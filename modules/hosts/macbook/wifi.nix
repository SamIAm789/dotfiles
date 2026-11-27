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
        wifi.backend = "iwd";
      };

      networking.wireless = {
        iwd.enable = true;
        enable = lib.mkForce false;
      };
    };
}