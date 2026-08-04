{
  flake.modules.nixos.framework =
  {
    pkgs,
    ...
  }:
  {
    environment.systemPackages = with pkgs; [
      opencloud-desktop
    ];
  };
}
