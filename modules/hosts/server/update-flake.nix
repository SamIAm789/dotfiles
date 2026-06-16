{
  flake.modules.nixos.server =
  {
    config,
    pkgs,
    ...
  }:
  let
    deployUser = "deploy";
    deployHome = "/var/lib/deploy";
    repoPath = "${deployHome}/dotfiles";
    githubRepo = "git@github-config:SamIAm789/dotfiles.git";
  in
  {

    sops.secrets.github-bot-key = {
      owner = deployUser;
      group = deployUser;
      mode = "0400";
    };

    sops.secrets.github-secrets-deploy-key-deploy = {
      owner = "deploy";
      group = "deploy";
      mode = "0400";
    };

    users.users.${deployUser} = {
      isSystemUser = true;
      group = deployUser;
      home = deployHome;
      createHome = true;
      shell = pkgs.bash;
      description = "github automation user";
    };

    users.groups.${deployUser} = {};

    programs.ssh.extraConfig = ''
      Host github-config
      HostName github.com
      User git
      IdentityFile ${config.sops.secrets.github-bot-key.path}
      IdentitiesOnly yes
      StrictHostKeyChecking accept-new
    '';

    systemd.tmpfiles.rules = [
      "d ${deployHome} 0755 ${deployUser} ${deployUser} -"
      "d ${repoPath} 0755 ${deployUser} ${deployUser} -"
    ];

    systemd.services.flake-update = {
      description = "Nightly flake.lock update";

      path = [ pkgs.git pkgs.nix pkgs.openssh pkgs.coreutils ];

      serviceConfig = {
        Type = "oneshot";
        User = deployUser;
        WorkingDirectory = repoPath;
      };

      environment = {
        HOME = deployHome;
        GIT_SSH_COMMAND = "${pkgs.openssh}/bin/ssh -F /etc/deploy-ssh-config -i ${config.sops.secrets.github-secrets-deploy-key-deploy.path}";
      };

      script = ''
        set -euo pipefail

        cd ${repoPath}

        if [ ! -d .git ]; then
          git clone "${githubRepo}" .
        fi

        current_origin="$(git remote get-url origin 2>/dev/null || true)"

        if [ "$current_origin" != "${githubRepo}" ]; then
          echo "Fixing origin remote"
          if git remote | grep -qx origin; then
            git remote set-url origin "${githubRepo}"
          else
            git remote add origin "${githubRepo}"
          fi
        fi

        git fetch origin
        git reset --hard origin/main

        nix flake update

        git add -A flake.lock

        if git diff --cached --quiet; then
          echo "No changes"
          exit 0
        fi

        git config user.name "github-bot"
        git config user.email "github-bot@example.com"

        git commit -m "flake: nightly update $(date +%F)"
        git push origin HEAD:main

      '';
    };

    systemd.timers.flake-update = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
      };
    };
  };
}
