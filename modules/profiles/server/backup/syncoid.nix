{
  flake.modules.nixos.syncoid =
    {
      pkgs,
      ...
    }:
    {
      users.users.backup = {
        isSystemUser = true;
        group = "backup";
        home = "/var/lib/backup";
        createHome = true;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINHl0zA061dpCTG2lDEFiAd0IfXZ+GF/Cun9l7/WcD6B syncoid"
        ];
      };

      users.groups.backup = {};

      environment.systemPackages = [
        pkgs.lzop
        pkgs.mbuffer
      ];

      services.openssh.extraConfig = ''
        Match User backup
        PasswordAuthentication no
        X11Forwarding no
        AllowTcpForwarding no
        PermitTTY no
      '';
    };
}
