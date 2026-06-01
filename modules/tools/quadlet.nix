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
      isNormalUser = true;
      linger = true;
      autoSubUidGidRange = true;
    };
  };
}
