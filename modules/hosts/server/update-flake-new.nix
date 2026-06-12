{
  flake.modules.nixos.server =
  {
    pkgs,
    ...
  }:
  let
    deployUser = "deploy";
    deployHome = "/var/lib/deploy";
    repoPath = "${deployHome}/dotfiles";
  in
  {

    systemd.tmpfiles.rules = [
        "d ${deployHome}           0750 deploy deploy -"
        "d ${deployHome}/.ssh      0700 deploy deploy -"
        "d ${repoPath}             0750 deploy deploy -"
      ];

    systemd.services.flake-update = {
      description = "Update flake inputs and push to GitHub";
      path = [ pkgs.git pkgs.nix pkgs.openssh pkgs.coreutils ];

      serviceConfig = {
        Type = "oneshot";
        User = deployUser;
        WorkingDirectory = repoPath;
        Restart = "on-failure";
        RestartSec = "30s";
        ProtectSystem = "full";
        ProtectHome = "read-only";
        PrivateTmp = true;
        NoNewPrivileges = true;
        ReadWritePaths = [ deployHome repoPath ];
        Environment = "HOME=${deployHome}";
      };

      script = ''
          set -euo pipefail

                echo "=== Flake Update Service Starting ==="

                # Bootstrap if needed
                if [ ! -d ${repoPath}/.git ]; then
                  echo "Cloning repository..."
                  rm -rf ${repoPath}
                  git clone https://github.com/SamIAm789/dotfiles.git ${repoPath}
                  chown -R ${deployUser}:${deployUser} ${repoPath}
                fi

                cd ${repoPath}

                git remote set-url origin git@github-config:SamIAm789/dotfiles.git

                git config user.name "homelab-bot"
                git config user.email "bot@local"

                echo "Pulling latest changes..."
                git pull --rebase origin main

                echo "Updating flake inputs..."
                # Use SSH key specifically for the secrets repo
                GIT_SSH_COMMAND="ssh -i /run/secrets/github-secrets-key -o StrictHostKeyChecking=accept-new" \
                  nix flake update

                if git diff --quiet flake.lock; then
                  echo "No changes to flake.lock"
                  exit 0
                fi

                echo "Committing and pushing..."
                git add flake.lock
                git commit -m "chore(flake): automatic update $(date +%Y-%m-%d)"
                GIT_SSH_COMMAND="ssh -i /run/secrets/github-bot-key -o StrictHostKeyChecking=accept-new" \
                git push origin main

                echo "✅ Flake successfully updated and pushed"
      '';

      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
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
