{
  flake.modules.nixos.autoupdate = {

    system.autoUpgrade = {
      enable = true;
      flake = "github:SamIAm789/dotfiles";
      allowReboot = true;
      rebootWindow = {
        lower = "02:00";
        upper = "05:00";
      };
      dates = "02:00";
    };
  };
}
