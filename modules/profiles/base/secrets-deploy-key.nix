{
  inputs,
  ...
}:
{
  flake.modules.nixos.secrets-deploy-key =
    {
      config,
      ...
    }:
    {

      sops = {

        secrets.github-secrets-deploy-key = { };


      };

      environment.etc."ssh/ssh_config.d/00-deploy.conf".text = ''
        Match User root
        Host github.com
        IdentityFile ${config.sops.secrets.github-secrets-deploy-key.path}
        IdentitiesOnly yes
      '';

      systemd.tmpfiles.rules = [
        "d /etc/ssh/keys 0700 root root -"
      ];
    };
}
