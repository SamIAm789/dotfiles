{
  flake.modules.nixos.esphome = {
    services.esphome = {
      enable = true;
      allowedDevices = [
        "char-ttyUSB"
        "char-ttyS"
      ];
    };
  };
}
