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
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGS8uEXOYevF6nZK+2zfUTm4k1Gh1RDYP3nyTG4raPBL syncoid"
        ];
      };
      environment.systemPackages = [
        pkgs.lzop
        pkgs.mbuffer
      ];
    };
}
