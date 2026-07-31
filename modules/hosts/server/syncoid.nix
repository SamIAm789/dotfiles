{
  flake.modules.nixos.server =
  {
    pkgs,
    ...
  }:
  {
    users.users.backup = {
      isSystemUser = true;
      group = "backup";
      shell = pkgs.bashInteractive;
      openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINHl0zA061dpCTG2lDEFiAd0IfXZ+GF/Cun9l7/WcD6B syncoid" ];
    };
    users.groups.backup = {};
  };
}
