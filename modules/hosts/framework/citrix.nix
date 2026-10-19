{
  flake.modules.nixos.framework =
  {
    pkgs,
    ...
  }:
  {
    environment.systemPackages = with pkgs; [
      citrix_workspace
    ];
  };
}
