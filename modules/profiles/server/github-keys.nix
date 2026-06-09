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
        defaultSopsFile = "${inputs.secrets}/secrets.yaml";
        age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

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

      environment.etc."ssh/ssh_known_hosts".text = ''
        github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0Ds8L7hG1SH1m0J1j4k4v9Qv4X5Y5Qv4
        github.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5JHBVpfXh9OQ6+1+1uOQv4X5Y5Qv4=
      '';

      environment.etc."deploy-ssh-config".text = ''
        Host github-config
        HostName github.com
        User git
        IdentityFile ${config.sops.secrets.github-bot-key.path}
        IdentitiesOnly yes
        StrictHostKeyChecking accept-new

        Host github-secrets
        HostName github.com
        User git
        IdentityFile ${config.sops.secrets.github-secrets-key.path}
        IdentitiesOnly yes
        StrictHostKeyChecking accept-new
      '';

      systemd.tmpfiles.rules = [
        "d ${deployHome}/.ssh 0700 ${deployUser} ${deployUser} -"
        "L+ ${deployHome}/.ssh/config - - - - /etc/deploy-ssh-config"
      ];

      programs.ssh.extraConfig = ''
        Match User ${personalUser} Host github.com
        IdentityFile ${config.sops.secrets.github-personal-key.path}
        IdentitiesOnly yes
      '';
    };
}
