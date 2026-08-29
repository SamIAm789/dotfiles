{
  flake.modules.nixos.router = 
  let
    wanIF     = "eth0";
    lanIF     = "br-lan";
    lanNet    = "10.25.0";
    routerIP  = "10.25.0.1";
    lanCIDR   = "10.25.0.0/24";
    domain    = "internal";
    dhcpStart = "10.25.0.100";
    dhcpEnd   = "10.25.0.200";
  in
  { };
}