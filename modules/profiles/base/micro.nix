{
  flake.modules.nixos.base =
  {
    pkgs,
    ...
  }:
  {
    environment.sessionVariables = {
      EDITOR = "micro";
      VISUAL = "micro";
    };

    environment.systemPackages = with pkgs; [
      micro
    ];
  };
}
