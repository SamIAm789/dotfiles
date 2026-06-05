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
      isNormalUser = false;
      isSystemUser = true;
      linger = true;
      autoSubUidGidRange = true;
      uid = 1002;
    };
    systemd.user.services.dbus.enable = true;
  };
}
