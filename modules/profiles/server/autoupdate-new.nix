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

    startAt = "01:00";
    restartIfChanged = false;

    path = [ pkgs.git pkgs.openssh ];

    serviceConfig = {
      Type = "oneshot";
      User = deployUser;
      WorkingDirectory = repoPath;

      Environment = [
        "HOME=${deployHome}"
        "GIT_SSH_COMMAND='ssh -F /etc/deploy-ssh-config'"
      ];
    };

    script = ''
      set -euo pipefail

      echo "=== Pulling public dotfiles ==="

      if [ ! -d ${repoPath}/.git ]; then
        rm -rf ${repoPath}
        git clone https://github.com/SamIAm789/dotfiles.git ${repoPath}
      fi

      cd ${repoPath}

      git config user.name "homelab-bot"
      git config user.email "bot@local"

      git pull --ff-only origin main
    '';
  };

  # === Official auto-upgrade (runs after pull) ===
  system.autoUpgrade = {
    enable = true;
    flake = "github:SamIAm789/dotfiles";
    allowReboot = true;
    rebootWindow = {
      lower = "02:00";
      upper = "05:00";
    };
    dates = "02:00";
  };
};
}
