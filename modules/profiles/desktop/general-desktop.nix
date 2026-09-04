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
      polkit
      power-management
      secret-service
      wifi
    ];

    environment.systemPackages = with pkgs; [
      libreoffice-stable
      hunspell
      hunspellDicts.en-gb-large
    ];

    home-manager.sharedModules = with inputs.self.modules.homeManager; [
      zed
      secret-service
    ];
  };
}
