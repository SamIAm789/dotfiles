{
  flake.modules.nixos.oracle =
    { ... }:
    {
      networking.useDHCP = false;

      systemd.network = {
        enable = true;
        networks."10-oci" = {
          matchConfig.Name = "ens3";
          networkConfig.DHCP = "ipv4";
          dhcpV4Config = {
            UseDNS = true;
          };
          linkConfig.RequiredForOnline = "routable";
        };
      };
    };
}
