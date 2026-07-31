{
  flake.modules.nixos.syncoid =
    {
      pkgs,
      ...
    }:
    {
      users.users.backup = {
        isNormalUser = true;
        createHome = false;
        home = "/var/empty";
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINHl0zA061dpCTG2lDEFiAd0IfXZ+GF/Cun9l7/WcD6B syncoid"
        ];
      };
      environment.systemPackages = [
        pkgs.lzop
        pkgs.mbuffer
      ];
    };
}
