{
  flake.modules.nixos.esphome = {
    service.esphome = {
      enable = true;
      allowedDevices = [
        "char-ttyUSB"
        "char-ttyS"
      ];
    };
  };
}
