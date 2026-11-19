{
  flake.modules.nixos.framework =
  {
    pkgs,
    ...
  }:
  {
    environment.systemPackages = with pkgs; [
      citrix-workspace
    ];
    nixpkgs.config.permittedInsecurePackages = [
      "libsoup-2.74.3"
    ];
  };
}
