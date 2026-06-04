{
  flake.modules.nixos.wifi = {
    networking = {
      wireless.enable = true;
      networkmanager = {
        enable = true;
        wifi.backend = "iwd";
      };
    };
  };
}
