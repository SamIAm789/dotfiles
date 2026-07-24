{
  flake.modules.nixos.thinkpad =
  {
    pkgs,
    ...
  }:
  {

    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;

    environment.gnome.excludePackages = with pkgs; [
      gnome-music
      gnome-tour
      gnome-weather
      epiphany
      simple-scan
      totem
    ];

    services.flatpak.enable = true;

    programs.firefox.enable = true;

    environment.systemPackages = with pkgs; [
      google-chrome
      gnomeExtensions.dash-to-dock
      libreoffice-fresh
    ];
  };
}
