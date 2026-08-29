{
  flake.modules.nixos router = {

    services.unbound = {
      enable = true;
      settings = {
        server = {
          interface = [
            "127.0.0.1"
            "::1"
          ];
          access-control = [
            "127.0.0.0/8 allow"
            "::1 allow"
          ];

          verbosity = 1;
          do-ip4 = true;
          do-ip6 = true;
          do-udp = true;
          do-tcp = true;

          hide-identity = true;
          hide-version = true;
          qname-minimisation = true;
          harden-glue = true;
          harden-dnssec-stripped = true;

          prefetch = true;
          prefetch-key = true;
          cache-min-ttl = 60;
          cache-max-ttl = 86400;
          serve-expired = true;

          private-address = [
            "10.0.0.0/8"
            "172.16.0.0/12"
            "192.168.0.0/16"
            "169.254.0.0/16"
            "fd00::/8"
            "fe80::/10"
          ];

          root-hints = "${pkgs.dns-root-data}/root.hints";
        };
      };
    };
  };
}