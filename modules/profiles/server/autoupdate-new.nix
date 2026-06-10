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
      };

      script = ''
        set -euo pipefail
        export HOME=${deployHome}
        export GIT_SSH_COMMAND="ssh -F ${deployHome}/.ssh/config"

        # Bootstrap if needed
        if [ ! -d ${repoPath}/.git ]; then
          echo "Cloning repository..."
          rm -rf ${repoPath}
          git clone git@github-config:SamIAm789/dotfiles.git ${repoPath}
        fi

        cd ${repoPath}

        git config user.name "homelab-bot"
        git config user.email "bot@local"

        echo "Pulling latest changes..."
        git pull --ff-only origin main
      '';

      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
    };

    system.autoUpgrade = {
      enable = true;
      flake = "git+file://${repoPath}";

      allowReboot = true;
      rebootWindow = {
        lower = "02:00";
        upper = "05:00";
      };

      dates = "02:00";
    };
  };
}
