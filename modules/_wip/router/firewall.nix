{
  flake.modules.nixos.router = {

    networking.firewall = {
      enable = true; 
      filterForward = true;
      trustedInterfaces = [ ${lanIF} ];
      allowed
      extraForwardRules = ''
        iifname "\( ${lanIF}" oifname " \)${wanIF}" accept
      '';
    };
  };
}