{
  flake.modules.nixos.autoupdate =
  {
    pkgs,
    ...
  }:
  let
    deployHome = "/var/lib/deploy";
    repoPath = "${deployHome}/dotfiles";
  in
  {
    systemd.tmpfiles.rules = [
      "d ${deployHome}      0750 deploy deploy -"
      "d ${deployHome}/.ssh 0700 deploy deploy -"
      "d ${repoPath} 0750 ${deployUser} ${deployUser} -"
    ];

    systemd.services.pull-updates = {
      description = "Pulls changes to system config";
      restartIfChanged = false;
      startAt = "01:00";
      path = [ pkgs.git pkgs.openssh ];
      serviceConfig = {
        Type = "oneshot";
        User = "deploy";
        WorkingDirectory = repoPath;
        Restart = "on-failure";
        ReadWritePaths = [ deployHome ];
        PrivateTmp = true;
        NoNewPrivileges = true;
      };
      script = ''
        set -euo pipefail
        export HOME=${deployHome}
        export GIT_SSH_COMMAND="ssh -F ${deployHome}/.ssh/config"

        echo "=== pull-updates starting ==="

        # Bootstrap if needed (public repo → HTTPS recommended)
        if [ ! -d ${repoPath}/.git ]; then
          echo "Cloning repository for the first time..."
          rm -rf ${repoPath}
          git clone --depth 1 https://github.com/SamIAm789/dotfiles.git ${repoPath}
        fi

        cd ${repoPath}
        git config user.name "homelab-bot"
        git config user.email "bot@local"

        echo "Pulling latest changes..."
        git pull --ff-only origin main
        echo "=== pull-updates complete ==="
      '';
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
    };

    environment.etc."gitconfig-root".text = ''
      [safe]
        directory = ${repoPath}
      [user]
        name = "homelab-bot"
        email = "bot@local"
    '';

    systemd.services.nixos-upgrade = {
      description = "NixOS Upgrade with nh";
      restartIfChanged = false;
      startAt = "02:00";
      path = [ pkgs.nh pkgs.git pkgs.openssh config.nix.package ];
      serviceConfig = {
        Type = "oneshot";
        User = "root";              # nh os switch needs root
        WorkingDirectory = repoPath;
        Restart = "on-failure";
        RestartSec = "30s";
        ProtectSystem = "strict";
        ReadWritePaths = [ "/nix" "/boot" "${repoPath}" ];
      };
      script = ''
        set -euo pipefail
        echo "=== Starting NixOS upgrade with nh ==="

        nh os switch ${repoPath}

        echo "✅ Upgrade completed successfully"
      '';
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
    };
  };
}
