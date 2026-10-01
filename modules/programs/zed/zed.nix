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
        "docker-compose"
        "lua"
        "nix"
        "toml"
        "yaml"
      ];
    };
    home.packages = with pkgs; [
      nil
      nixd
    ];
  };
}
