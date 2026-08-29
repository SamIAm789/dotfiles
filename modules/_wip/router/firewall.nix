{
  flake.modules.nixos.router = {

    networking.firewall = {
      enable = true;
      checkReversePath = true;
      filterForward = true;
      trustedInterfaces = [ ${lanIF} ];
      allowed
      extraForwardRules = ''
        iifname "\( ${lanIF}" oifname " \)${wanIF}" accept
      '';
    };
  };
}