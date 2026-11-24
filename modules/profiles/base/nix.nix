{
  flake.modules.nixos.nix =
    {

      nixpkgs.config.allowUnfree = true;

      nix.settings = {
        auto-optimise-store = true;
        experimental-features = [ "nix-command" "flakes" ];
      };
    };
}
