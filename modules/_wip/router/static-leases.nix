{
  flake.modules.nixos.router = {

    services.dnsmasq.settings.dhcp-host = [
    # MAC, IP, hostname, lease time

      "aa:bb:cc:dd:ee:ff,10.25.0.10,server,infinite"
    "11:22:33:44:55:66,10.25.0.11,nas,24h"
    "de:ad:be:ef:00:01,10.25.0.20,printer"
  ];
  };
}