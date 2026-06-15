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
      deployUser = "deploy";
      deployHome = "/var/lib/deploy";
      repoPath = "${deployHome}/dotfiles";
      personalUser = "sam";
    in
    {
      users.groups.${deployUser} = {};

      users.users.${deployUser} = {
        isSystemUser = true;
        group = deployUser;
        home = deployHome;
        createHome = true;
        shell = pkgs.bash;
        description = "Deployment automation user";
      };

      sops = {

        secrets.github-bot-key = {
          owner = deployUser;
          group = deployUser;
          mode = "0400";
        };

        secrets.github-secrets-key = {
          owner = deployUser;
          group = deployUser;
          mode = "0400";
        };

        secrets.github-personal-key = {
          owner = personalUser;
          group = "users";
          mode = "0400";
        };
      };

      environment.etc."deploy-ssh-config".text = ''
        Host github-config
          HostName github.com
          User git
          IdentityFile ${config.sops.secrets.github-bot-key.path}
          IdentitiesOnly yes

        Host github-secrets
          HostName github.com
          User git
          IdentityFile ${config.sops.secrets.github-secrets-key.path}
          IdentitiesOnly yes
      '';

      systemd.tmpfiles.rules = [
        "d /var/lib/deploy/.ssh 0700 deploy deploy -"
        "L+ /var/lib/deploy/.ssh/config - - - - /etc/deploy-ssh-config"
      ];

      programs.ssh.extraConfig = ''
        Match User ${personalUser} Host github.com
          IdentityFile ${config.sops.secrets.github-personal-key.path}
          IdentitiesOnly yes
      '';
    };
}
