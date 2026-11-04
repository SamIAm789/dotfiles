{
  inputs,
  ...
}:
{
  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "server";

  flake.modules.nixos.server = {

    imports = with inputs.self.modules.nixos; [
      disko
      deploy-rs-source
      jellyfin
      nfs
      opencloud
      pinchflat
      prometheus-server
      sam
      server-profile
      server-filesystems
      server-hardware
      syncoid
    ];

    system.stateVersion = "25.11";

  };
}
