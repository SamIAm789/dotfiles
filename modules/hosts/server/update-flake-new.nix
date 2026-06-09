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

    systemd.services.flake-update = {
      description = "Update flake inputs and push to GitHub";
      path = [ pkgs.git pkgs.nix pkgs.openssh pkgs.coreutils ];

      serviceConfig = {
        Type = "oneshot";
        User = deployUser;
        WorkingDirectory = repoPath;
        Restart = "on-failure";
        RestartSec = "30s";

        # Security hardening
        ProtectSystem = "full";
        ProtectHome = "read-only";
        PrivateTmp = true;
        PrivateDevices = true;
        NoNewPrivileges = true;
        ReadWritePaths = [ repoPath ];
      };

      script = ''
        set -euo pipefail
        export HOME=/var/lib/deploy

        # Default for normal git operations (bot key)
        export GIT_SSH_COMMAND="ssh -F /var/lib/deploy/.ssh/config"

        # Bootstrap
        if [ ! -d ${repoPath}/.git ]; then
          echo "Cloning dotfiles repo..."
          rm -rf ${repoPath}
          git clone git@github-config:SamIAm789/dotfiles.git ${repoPath}
        fi

        cd ${repoPath}

        git config user.name "homelab-bot"
        git config user.email "bot@local"

        git pull --rebase origin main

        # Update flake with explicit secrets key
        echo "Updating flake inputs..."
        GIT_SSH_COMMAND="ssh -i /run/secrets/github-secrets-key \
                         -o StrictHostKeyChecking=accept-new \
                         -o IdentitiesOnly=yes" \
          nix flake update --commit-lock-file-inputs || true

        if git diff --quiet flake.lock; then
          echo "No changes"
          exit 0
        fi

        git add flake.lock
        git commit -m "chore(flake): automatic update $(date +%Y-%m-%d)"
        git push origin main
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
