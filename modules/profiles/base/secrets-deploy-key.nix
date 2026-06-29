{
  flake.modules.nixos.secrets-deploy-key =
    {
      config,
      ...
    }:
    {

      sops = {

        secrets.github-secrets-deploy-key = {
          owner = "root";
          group = "root";
          mode = "0400";
        };


      };

      programs.ssh.knownHosts = {
        github = {
          hostNames = [ "github.com" ];
          public key = "github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
        };
      };

      programs.ssh.extraConfig = ''
        Host github-secrets
          HostName github.com
          User git
          IdentityFile ${config.sops.secrets.github-secrets-deploy-key.path}
          IdentitiesOnly yes
          StrictHostKeyChecking accept-new
      '';
    };
}
