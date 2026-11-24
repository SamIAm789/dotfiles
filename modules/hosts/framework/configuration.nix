{
  inputs,
  ...
}:
{

  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "framework";

  flake.modules.nixos.framework =
  {
    pkgs,
    ...
  }:
  {
    imports = with inputs.self.modules.nixos; [
      avahi
      deploy-rs-source
      framework-hardware
      laptop
      sam
      esphome
    ];

    home-manager.sharedModules = with inputs.self.modules.homeManager; [
      wluma-framework
    ];

    services.fprintd.enable = true;

    environment.systemPackages = with pkgs; [
      bottles
      scrcpy
      vlc
    ];

    system.stateVersion = "25.05";
  };
}
