{
  flake.modules.nixos.deploy-rs = {

    users.users.deploy = {
      isSystemUser = true;
      group = "deploy";
      openssh.authorizedKeys.keys = [
        ''SHA256:lGEYkZEJ8LP40VxPDSXQ/dh+yh3NESOEz2dwNIZ7JaM deploy-rs''
      ];
      extraGroups = [ ];
    };

    users.groups.deploy = {};

    security.sudo.extraRules = [{
      users = [ "deploy" ];
      commands = [{
        command = "ALL";
        options = [ "NOPASSWD" ];
      }];
    }];
  };
}
