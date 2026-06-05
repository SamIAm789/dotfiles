{

  flake.modules.homeManager.zed =
  {
    pkgs,
    ...
  }:
  {

    programs.zed-editor = {
      enable = true;
      extensions = [
        "nix"
        "toml"
        "docker-compose"
        "yaml"
      ];
    };
    home.packages = with pkgs; [
      nil
      nixd
    ];
  };
}
