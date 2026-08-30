{
  flake.modules.nixos.router = {

    services.dnsmasq = {
      enable = true;
      resolveLocalQueries = true;

      settings = {
        interface = [ lanIF "lo" ];
        bind-interfaces = true;
        except-interface = [ wanIF ];

        # DHCP
        dhcp-authoritative = true;
        dhcp-range = [ "\( {lanNet}.100, \){lanNet}.200,12h" ];
        dhcp-option = [
          "option:router,${router}"
          "option:dns-server,${router}"
          "option:domain-search,${domain}"
        ];

        # Local DNS
        domain = domain;
        local = "/${domain}/";
        expand-hosts = true;
        domain-needed = true;
        bogus-priv = true;
        no-resolv = true;
        no-hosts = true;

        # Everything else → unbound
        server = [ "127.0.0.1#5353" ];

        cache-size = 1000;
      };
    };
  };
}
