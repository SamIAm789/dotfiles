{
  flake.modules.nixos.framework-1 =
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
