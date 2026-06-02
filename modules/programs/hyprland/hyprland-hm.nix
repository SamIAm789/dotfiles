{
  inputs,
  ...
}:
{
  flake.modules.homeManager.hyprland = {

    imports = with inputs.self.modules.homeManager; [
      ashell
      fuzzel
      hypridle
      hyprlock
      wpaperd
    ];
  };
}
