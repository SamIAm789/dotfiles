{
  flake.modules.nixos.nix =
    {

      nixpkgs.config.allowUnfree = true;

      nix.settings = {
        auto-optimise-store = true;
        experimental-features = [ "nix-command" "flakes" ];
      };

      programs.nh = {
        enable = true;
        flake = "/home/sam/dotfiles";
        clean = {
          enable = true;
          extraArgs = "--keep-since 14d";
        };
      };
    };
}
