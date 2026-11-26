{
  flake.modules.nixos.macbook-wifi = {

    boot.extraModprobeConfig = ''
      options brcmfmac roamoff=1
    '';

      networking.networkmanager.wifi.powersave = false;
  };
}