{
  flake.modules.nixos.oracle =
  {
    lib,
    ...
  }:
  {

    services.nebula.networks.pertaka = {
      isRelay = lib.mkForce true;
      isLighthouse = lib.mkForce true;
      lighthouses = lib.mkForce [ ];
    };
  };
}