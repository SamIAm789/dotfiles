{
  flake.modules.nixos.router = {

    networking = {
      useDHCP = false;
      interfaces.wanIF.useDHCP = true;
      networkmanager.enable = lib.mkForce false;
    };

    boot.kernel.sysctl = {
      "net.ipv4.conf.all.forwarding" = true;
      "net.ipv6.conf.all.forwarding" = false;
    };
  };
}
