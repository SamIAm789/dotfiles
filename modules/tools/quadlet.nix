{
  inputs,
  ...
}:
{
  flake-file.inputs = {
    quadlet-nix.url = "github:SEIAROTg/quadlet-nix";
  };

  flake.modules.nixos.quadlet =
    {
      pkgs,
      ...
    }:
    {

    imports = [ inputs.quadlet-nix.nixosModules.quadlet ];

    users.users.containers = {
      isNormalUser = true;
      linger = true;
      autoSubUidGidRange = true;
      group = "containers";
    };
    users.groups.containers = {};

    virtualisation = {
      quadlet.enable = true;
      podman.enable = true;
    };
  };
}
