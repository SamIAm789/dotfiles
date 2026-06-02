{
  inputs,
  ...
}:
{
  flake.modules.nixos.general-desktop =
  {
    pkgs,
    ...
  }:
  {
    imports = with inputs.self.modules.nixos; [
      dbus
      firefox
      flatpak
      hardware
      kdeconnect
      pipewire
      power-management
      wifi
    ];

    environment.systemPackages = with pkgs; [
      libreoffice-fresh
    ];

    home-manager.sharedModules = with inputs.self.modules.homeManager; [
      zed
    ];
  };
}
