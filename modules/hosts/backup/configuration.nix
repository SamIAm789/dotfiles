{
  inputs,
  ...
}:
{
  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "backup";

  flake.modules.nixos.backup = {

    imports = with inputs.self.modules.nixos; [
      disko
      sam
      server-profile
      backup-hardware
      syncoid
    ];

    system.stateVersion = "25.11";

  };
}
