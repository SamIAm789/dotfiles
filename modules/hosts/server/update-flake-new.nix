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
        "d ${deployHome} 0750 deploy deploy -"
        "d ${repoPath} 0750 deploy deploy -"
      ];

    systemd.services.flake-update = {
      description = "Update flake inputs and push to GitHub";
      path = [ pkgs.git pkgs.nix pkgs.openssh pkgs.coreutils ];

      serviceConfig = {
        Type = "oneshot";
        User = "deploy";
        WorkingDirectory = repoPath;
        Restart = "on-failure";
        RestartSec = "30s";

        # Softened security settings to allow directory creation
        ProtectSystem = "full";
        ProtectHome = "read-only";
        PrivateTmp = true;
        PrivateDevices = true;
        NoNewPrivileges = true;
        ReadWritePaths = [ deployHome ];
      };

      script = ''
        set -euo pipefail
      export HOME=${deployHome}
        export GIT_SSH_COMMAND="ssh -F ${deployHome}/.ssh/config"

      echo "Working directory: ${repoPath}"

      # Bootstrap if needed
      if [ ! -d ${repoPath}/.git ]; then
        echo "Cloning configuration repository for the first time..."
        rm -rf ${repoPath}
          git clone git@github-config:SamIAm789/dotfiles.git ${repoPath}
          chown -R deploy:deploy ${repoPath}
        fi

      cd ${repoPath}

        git config user.name "homelab-bot"
      git config user.email "bot@local"

      echo "Pulling latest changes..."
      git pull --rebase origin main

      echo "Updating flake inputs (including secrets)..."
      GIT_SSH_COMMAND="ssh -i /run/secrets/github-secrets-key -o StrictHostKeyChecking=accept-new" \
        nix flake update --commit-lock-file-inputs || true

      if git diff --quiet flake.lock; then
        echo "No changes to flake.lock"
        exit 0
      fi

      echo "Committing and pushing..."
      git add flake.lock
      git commit -m "chore(flake): automatic update $(date +%Y-%m-%d)"
      git push origin main

      echo "✅ Flake update completed successfully"
    '';

      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
    };

    systemd.timers.flake-update = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "hourly";
        Persistent = true;
        RandomizedDelaySec = "15min";
      };
    };
  };
}
