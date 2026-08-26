{
  flake.modules.nixos.deploy-rs = {

    users.users.deploy = {
      isNormalUser = true;
      description = "deploy-rs activation user";
      hashedPassword = "!";
      extraGroups = [ ];
      openssh.authorizedKeys.keys = [
        # Paste the public key you will use for deploys

      ];
      home = "/var/lib/deploy";
      createHome = true;
    };

    security.sudo.extraRules = [
      {
        users = [ "deploy" ];
        commands = [
          {
            # activate-rs lives inside each new system closure
            command = "/nix/store/*/activate-rs";
            options = [ "NOPASSWD" ];
          }
          {
            # magic-rollback lock cleanup
            command = "/run/current-system/sw/bin/rm";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];
  };
}
