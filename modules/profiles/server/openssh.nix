{
  flake.modules.nixos.openssh = {
    services.openssh.enable = true;
    listenAddresses = [
      { addr = "0.0.0.0"; port = 22; }
      { addr = "::"; port = 22; }
    ];
    permitRootLogin = "no";
  };
}
