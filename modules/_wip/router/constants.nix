flake.modules.nixos.router =
  { 
    lib,
    ... 
  }:
  let
    lanNet = "10.25.0";

    defaults = {
      wanInterface = "eth0";
      lanInterface = "br-lan";
      inherit lanNet;
      routerIP = "${lanNet}.1";
      lanCIDR = "${lanNet}.0/24";
      domain = "internal";
      dhcpStart = "${lanNet}.100";
      dhcpEnd = "${lanNet}.200";
    };
  in
  {
    options.router = lib.mapAttrs
      (_: default: lib.mkOption {
        type = lib.types.str;
        inherit default;
      })
      defaults;
  };