{
  flake.modules.nixos.router =
  {
    config,
    ...
  }:
  let
    cfg = config.router;
  in
  {

    services.dnsmasq = {
      enable = true;
      resolveLocalQueries = true;

      settings = {
        interface = [ cfg.lanIF "lo" ];
        bind-interfaces = true;
        except-interface = [ cfg.wanIF ];

        # DHCP
        dhcp-authoritative = true;
        dhcp-range = [ "${cfg.dhcpStart},${cfg.dhcpEnd}" ];
        dhcp-option = [
          "option:router,${cfg.routerIP}"
          "option:dns-server,${cfg.routerIP}"
          "option:domain-search,${cfg.domain}"
        ];

        # Local DNS
        domain = cfg.domain;
        local = "/${cfg.domain}/";
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
