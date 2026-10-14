{
  flake.modules.nixos.firewall-vps = {

    networking.firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
      allowedUDPPorts = [ 4242 ];
      logRefusedConnections = false;
    };

    networking.nftables.enable = true;
  };
}