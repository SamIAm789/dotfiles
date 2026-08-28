{
  flake.modules.nixos.deploy-rs = {

    users.users.deploy.openssh.authorizedKeys.keys = [
        # Paste the public key you will use for deploys
    ];

    security.sudo.extraRules = [
      {
        users = [ "deploy" ];
        commands = [
          {
            command = "/run/current-system/sw/bin/nix-env";
            options = [ "NOPASSWD" ];
          }
          {
            command = "/nix/var/nix/profiles/system/bin/switch-to-configuration";
            options = [ "NOPASSWD" ];
          }
          # deploy-rs also needs to run its own activate script;
          # in practice many people still end up allowing a broader set
          # or just use NOPASSWD: ALL for the deploy user.
        ];
      }
    ];
  };
}
