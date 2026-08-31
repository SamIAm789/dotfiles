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
    networking.nat = {
      enable = true;
      externalInterface = cfg.wanIF;
      internalInterfaces = [ cfg.lanIF ];
    };
  };
}
