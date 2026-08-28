{
  flake.modules.nixos.deploy-rs = {

    users.users.deploy.openssh.authorizedKeys.keys = [
        # Paste the public key you will use for deploys
    ];

    security.sudo.extraRules = [{
      users = [ "deploy" ];
      commands = [{ command = "ALL"; options = [ "NOPASSWD" ]; }];
    }];
  };
}
