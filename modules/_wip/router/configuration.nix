{
  inputs,
  ...
}:
{
  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "router";

  flake.modules.nixos.router = {

    imports = with inputs.self.modules.nixos; [
      disko
      sam
      syncoid
      autoupdate
      base
      network
      ntfy
      openssh
      preservation
      quadlet
      sanoid
      zfs
    ];

    system.stateVersion = "26.05";

  };
}
