{
  flake.modules.nixos.deploy-rs = {

    users.users.deploy-rs = {
      isSystemUser = true;
      group = "deploy-rs";
      openssh.authorizedKeys.keys = [
        ''SHA256:lGEYkZEJ8LP40VxPDSXQ/dh+yh3NESOEz2dwNIZ7JaM deploy-rs''
      ];
      extraGroups = [ ];
    };

    users.groups.deploy-rs = {};

    security.sudo.extraRules = [{
      users = [ "deploy-rs" ];
      commands = [{
        command = "ALL";
        options = [ "NOPASSWD" ];
      }];
    }];
  };
}
