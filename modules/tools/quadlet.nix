{
  inputs,
  ...
}:
{
  flake-file.inputs = {
    quadlet-nix.url = "github:SEIAROTg/quadlet-nix";
  };

  flake.modules.nixos.quadlet = {

    imports = [ inputs.quadlet-nix.nixosModules.quadlet ];

    users.users.containers = {
      isSystemUser = true;
      linger = true;
      autoSubUidGidRange = true;
      group = "containers";
      createHome = "/var/lib/containers";
    };
    users.groups.containers = {};

    virtualisation = {
      quadlet.enable = true;
      podman.enable = true;
    };
  };
}
