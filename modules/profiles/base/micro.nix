{
  flake.modules.nixos.base =
  {
    pkgs,
    ...
  }:
  {
    environment.variables = {
      EDITOR = "micro";
      VISUAL = "micro";
    };

    environment.systemPackages = with pkgs; [
      micro
    ];
  }

  }
}
