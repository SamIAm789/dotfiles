{
  flake.modules.nixos.nfs = {

    services.nfs.server.enable = true;
    networking.firewall.allowedTCPPorts = [ 2049 ];
    networking.firewall.allowedUDPPorts = [ 2049 ];

  };
}
