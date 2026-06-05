{
  inputs,
  ...
}:
{
  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "server";

  flake.modules.nixos.server = {

    imports = with inputs.self.modules.nixos; [
      disko
      sam
      server-profile
      server-filesystems
      server-hardware
      syncoid
      skylite
    ];

    system.stateVersion = "25.11";

  };
}
