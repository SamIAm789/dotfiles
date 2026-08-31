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
    networking = {
      useDHCP = false;
      interfaces.${cfg.wanIF}.useDHCP = true;
      networkmanager.enable = lib.mkForce false;
    };

    boot.kernel.sysctl = {
      "net.ipv4.conf.all.forwarding" = true;
      "net.ipv6.conf.all.forwarding" = false;
    };
  };
}
