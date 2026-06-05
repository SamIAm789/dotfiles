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
      isSystemUser = false;
      linger = true;
      autoSubUidGidRange = true;
      uid = 1002;
      group = "containers";
      shell = pkgs.bashInteractive;
    };
    users.groups.containers = {};
  };
}
