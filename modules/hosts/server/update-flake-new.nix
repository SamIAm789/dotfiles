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
        WorkingDirectory = deployHome;
        Restart = "on-failure";
        RestartSec = "30s";
        ProtectSystem = "full";
        ProtectHome = "read-only";
        PrivateTmp = true;
        NoNewPrivileges = true;
        ReadWritePaths = [ deployHome ];
      };

      script = ''
        set -euo pipefail
        export HOME=${deployHome}
        export GIT_SSH_COMMAND="ssh -F ${deployHome}/.ssh/config"

        echo "=== Flake Update Service Starting ==="

        # Ensure directories exist
        mkdir -p ${repoPath}
        chown deploy:deploy ${deployHome} ${repoPath}

           # Bootstrap repo (updated to HTTPS fallback)
        if [ ! -d ${repoPath}/.git ]; then
          echo "Cloning repository for the first time..."
          rm -rf ${repoPath}
          git clone https://github.com/SamIAm789/dotfiles.git ${repoPath}
          chown -R deploy:deploy ${repoPath}
         fi

         cd ${repoPath}

         git config user.name "homelab-bot"
         git config user.email "bot@local"

         echo "Pulling latest changes..."
         git pull --rebase origin main

         echo "Updating flake inputs..."
         nix flake update

         if git diff --quiet flake.lock; then
           echo "No changes to flake.lock"
           exit 0
         fi

         echo "Committing and pushing..."
         git add flake.lock
         git commit -m "chore(flake): automatic update $(date +%Y-%m-%d)"
         git push origin main

         echo "✅ Flake successfully updated and pushed"
      '';

      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
    };

    systemd.timers.flake-update = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "*-*-* 00:00:00";
        Persistent = true;
      };
    };
  };
}
