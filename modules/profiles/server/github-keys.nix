{
  inputs,
  ...
}:
{
  flake.modules.nixos.github-keys =
    {
      config,
      pkgs,
      ...
    }:
    let
      personalUser = "sam";
    in
    {

      sops = {

        secrets.github-secrets-deploy-key = { };

        secrets.github-personal-key = {
          owner = personalUser;
          group = "users";
          mode = "0400";
        };
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

      programs.ssh.extraConfig = ''
        Match User ${personalUser} Host github.com
          IdentityFile ${config.sops.secrets.github-personal-key.path}
          IdentitiesOnly yes
      '';
    };
}
