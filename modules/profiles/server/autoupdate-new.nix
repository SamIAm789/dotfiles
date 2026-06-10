{
  flake.modules.nixos.autoupdate =
  {
    config,
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
    "d ${deployHome} 0750 ${deployUser} ${deployUser} -"
    "d ${deployHome}/.ssh 0700 ${deployUser} ${deployUser} -"
    "d ${repoPath} 0750 ${deployUser} ${deployUser} -"
  ];

  programs.git = {
  enable = true;
  config = {
    safe.directory = [ "${repoPath}" ];
    # Optional: also set bot identity for root
  };
};

  # === Git safe.directory for root (fixes your original error) ===
  environment.etc."gitconfig-root".text = ''
    [safe]
      directory = ${repoPath}
  '';

  systemd.services.pull-updates = {
    description = "Pull changes to system config";
    restartIfChanged = false;
    startAt = "01:00";
    path = [ pkgs.git pkgs.openssh ];
    serviceConfig = {
      Type = "oneshot";
      User = deployUser;
      WorkingDirectory = repoPath;
      Restart = "on-failure";
      RestartSec = "30s";
    };
    script = ''
      set -euo pipefail
      export HOME=${deployHome}

      # Bootstrap or fix remote if needed
      if [ ! -d ${repoPath}/.git ]; then
        echo "Cloning repository (HTTPS)..."
        rm -rf ${repoPath}
        git clone --depth 1 https://github.com/SamIAm789/dotfiles.git ${repoPath}
      else
        cd ${repoPath}
        # Force HTTPS remote if it's still SSH
        if git remote get-url origin | grep -q "github-config"; then
          echo "Switching origin to HTTPS..."
          git remote set-url origin https://github.com/SamIAm789/dotfiles.git
        fi
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

  # === Official auto-upgrade (runs after pull) ===
  system.autoUpgrade = {
    enable = true;
    flake = "${repoPath}";
    allowReboot = true;
    rebootWindow = {
      lower = "02:00";
      upper = "05:00";
    };
    dates = "02:00";
  };
};
}
