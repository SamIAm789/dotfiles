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
      hunspell
      hunspellDicts.en-gb-large
      libreoffice-stable
      micro
    ];

    home-manager.sharedModules = with inputs.self.modules.homeManager; [
      zed
    ];
  };
}
