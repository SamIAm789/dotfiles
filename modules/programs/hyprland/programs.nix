{
  flake.modules.nixos.hyprland =
  {
    pkgs,
    ...
  }:
  {

    environment.systemPackages = with pkgs; [
      joplin-desktop
      kitty
      swaynotificationcenter
      nautilus
      bluetuith
    ];
  };
}
