{
  inputs,
  ...
}:
{
  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "google";

  flake.modules.nixos.google = {

    imports = with inputs.self.modules.nixos; [
      base
    ];

    system.stateVersion = "26.05";

  };
}