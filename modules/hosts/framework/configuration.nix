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
      deploy-key-framework
      framework-hardware
      base
      laptop
      sam
    ];

    services.fprintd.enable = true;

    environment.systemPackages = with pkgs; [
      scrcpy
      vlc
      bottles
    ];

    system.stateVersion = "25.05";
  };
}
