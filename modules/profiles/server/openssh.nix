{
  flake.modules.nixos.openssh = {
    services.openssh = {
      enable = true;
      listenAddresses = [
        { addr = "0.0.0.0"; port = 22; }
      ];
      settings.PermitRootLogin = "no";
    };

  networking.firewall.interfaces."nebula.pertaka".allowedTCPPorts = [ 22 ];
  };
}
