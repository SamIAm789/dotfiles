{
  flake.modules.nixos.thinkpad =
  {
    pkgs,
    lib,
    ...
  }:
  {

    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;

    services.gnome.gcr-ssh-agent.enable = lib.mkForce false;

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
