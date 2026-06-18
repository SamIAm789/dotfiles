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
