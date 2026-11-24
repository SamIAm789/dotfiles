{
  flake.modules.nixos.polkit =
    {
      pkgs,
      ...
    }:
    {

      security.polkit.enable = true;
    };
}
