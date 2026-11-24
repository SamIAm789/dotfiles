{
  inputs,
  ...
}:
{
  flake.modules.nixos.laptop = {
    imports = with inputs.self.modules.nixos; [
      base
      general-desktop
      hardware
      hyprland
      nebula-dns
    ];

    home-manager.sharedModules = [
      inputs.self.modules.homeManager.laptop
    ];
  };
}
