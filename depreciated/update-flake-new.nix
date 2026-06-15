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

    sops.secrets.github-bot-key = {
      owner = deployUser;
      group = deployUser;
      mode = "0400";
    };

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

        ProtectSystem = "full";
        ProtectHome = "read-only";
        PrivateTmp = true;
        NoNewPrivileges = true;

        ReadWritePaths = [ deployHome repoPath ];

        Environment = [
          "HOME=${deployHome}"
          ''GIT_SSH_COMMAND=ssh -F /etc/deploy-ssh-config''
        ];
      };

      script = ''
        set -euo pipefail

        echo "=== Flake Update ==="

        # ALWAYS SSH clone (no HTTPS ever)
        if [ ! -d ${repoPath}/.git ]; then
          rm -rf ${repoPath}
          git clone git@github-config:SamIAm789/dotfiles.git ${repoPath}
        fi

        cd ${repoPath}

        git config user.name "homelab-bot"
        git config user.email "bot@local"

        git pull --rebase origin main

        echo "Updating flake inputs..."
        nix flake update

        git add flake.lock

        if git diff --cached --quiet; then
          echo "No changes"
          exit 0
        fi

        git commit -m "chore(flake): update $(date +%F)"

        git push origin main

        echo "DONE"
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
