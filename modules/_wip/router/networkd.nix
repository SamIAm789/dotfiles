{
  flake.modules.nixos.router = {
    systemd.network = {
      enable = true;
      wait-online.anyinterface = true;
      networks = {
        "10-wan" = {
          matchConfig.Name = "wan";
          networkConfig = {
            DHCP = "ipv4";
            DNSoverTLS = true;
            DNSSEC = true;
            IPForward = true;
          };
          linkConfig.RequiredForOnline = "routable";
        };
      };
    };
  };
}
