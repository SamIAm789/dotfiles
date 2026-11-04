{
  flake.modules.nixos.server = {

    boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

    networking.nftables = {
      enable = true;

      tables."nebula-forward" = {
        family = "inet";

        content = ''
          chain forward {
            type filter hook forward priority filter; policy drop;

            # Allow Nebula clients to access the home LAN
            iifname "nebula.pertaka" oifname "microbr" \
              ip saddr 100.100.0.0/22 \
              ip daddr 10.25.0.0/24 accept

            # Allow replies from the LAN to Nebula clients
            iifname "microbr" oifname "nebula.pertaka" \
              ip saddr 10.25.0.0/24 \
              ip daddr 100.100.0.0/22 \
              ct state established,related accept
          }
        '';
      };
    };
    services.nebula.networks.pertaka.firewall.inbound = [
      {
        host = "any";
        port = "any";
        proto = "any";
        local_cidr = "10.25.0.0/24";
      }
    ];
  };
}
