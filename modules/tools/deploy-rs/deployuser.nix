{
  flake.modules.nixos.deploy-rs = {

    users.users.deploy-rs = {
      isSystemUser = true;
      group = "deploy-rs";
      openssh.authorizedKeys.keys = [
        ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMf0rG0nKfoYN0EFRfpFJBnXPSAxq1MoT/bK+m9h1qWP deploy-rs''
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
