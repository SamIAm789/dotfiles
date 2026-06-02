{
  flake.modules.nixos.wifi = {
    networking.wireless.iwd = {
      enable = true;
      settings = {
        AutoConnect = true;
      };
    };
    networking.networkmanager = {
      enable = true;
      wifiBackend = "iwd";
    };
  };
}
