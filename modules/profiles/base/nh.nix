{
  flake.modules.nixos.nh =
    {

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
