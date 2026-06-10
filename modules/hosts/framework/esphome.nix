{
  flake.modules.nixos.esphome = {
    services.esphome = {
      enable = true;
      allowedDevices = [
        "char-ttyUSB"
        "char-ttyS"
      ];
    };
    programs.firefox = {
      policies = {
        DefaultSerialGuardSetting = 3; # Allows the API usage
        Preferences = {
          "dom.webserial.enabled" = true;
        };
      };
    };

    users.users.sam = {
      extraGroups = [ "dialout" ];
    };
  };
}
