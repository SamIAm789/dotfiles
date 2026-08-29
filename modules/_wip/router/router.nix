{
  flake.modules.nixos.router = {

    boot.kernel.sysctl = {
      "net.ipv4.ip_forward" = true;          
      "net.ipv6.conf.all.forwarding" = false;
    };
  };
}
