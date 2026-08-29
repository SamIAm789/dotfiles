{
  flake.modules.nixos.router = {

    networking.nftables.enable = true;

    networking.firewall = {
      enable = true;
      checkReversePath = true;
      filterForward = true;
      trustedInterfaces = [ ${lanIF} ];
      extraInputRules = ''
        iifname "${cfg.wanIF}" ip saddr \
        { 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 }
      '';
      extraForwardRules = ''
        iifname "\( ${lanIF}" oifname " \)${wanIF}" accept
      '';
    };
  };
}