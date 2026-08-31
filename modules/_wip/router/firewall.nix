{
  flake.modules.nixos.router =
  {
    config,
    ...
  }:
  let

  # Private / reserved ranges that should never appear as source on WAN
    bogons4 = [
      "0.0.0.0/8"
      "10.0.0.0/8"
      "100.64.0.0/10"
      "127.0.0.0/8"
      "169.254.0.0/16"
      "172.16.0.0/12"
      "192.0.0.0/24"
      "192.0.2.0/24"
      "192.168.0.0/16"
      "198.18.0.0/15"
      "198.51.100.0/24"
      "203.0.113.0/24"
    ];

    bogons6 = [
      "::/128"
      "::1/128"
      "fc00::/7"
      "fe80::/10"
    ];

    cfg = config.router;
  in
  {

    networking.nftables.enable = true;

    networking.firewall = {
      enable = true;
      allowPing = false;
      checkReversePath = "loose";
      filterForward = true;
      trustedInterfaces = [ cfg.lanIF ];
      extraInputRules = ''
        iifname wanIF ip saddr ${mkNftSet bogons4} drop
        iifname wanIF ip6 saddr ${mkNftSet bogons6} drop
      '';
      extraForwardRules = ''
        iifname "\( ${cfg.lanIF} oifname " \)${cfg.wanIF} accept
      '';
    };
  };
}
