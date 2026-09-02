{
  flake.modules.nixos.router =
    { lib, ... }:
    let
      defaults = {
        wanInterface = "eth0";
        lanInterface = "br-lan";
        lanNet = "10.25.0";
        routerIP = "10.25.0.1";
        lanCIDR = "10.25.0.0/24";
        domain = "internal";
        dhcpStart = "10.25.0.100";
        dhcpEnd = "10.25.0.200";
      };
    in
    {
      options.router = lib.mapAttrs
        (_: default: lib.mkOption {
          type = lib.types.attrsOf lib.types.str;
          inherit default;
        })
        defaults;
    };
}
