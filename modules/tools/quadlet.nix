{
  inputs,
  ...
}:
{
  flake-file.inputs = {
    quadlet-nix.url = "github:SEIAROTg/quadlet-nix";
  };

  imports = [ inputs.quadlet-nix.flakeModules.quadlet ];

  users.users.containers = {
    isNormalUser = true;
    linger = true;
    autoSubUidGidRange = true;
  };
}
