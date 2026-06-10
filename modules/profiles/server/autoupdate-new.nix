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

  # === Git safe.directory for root (fixes your original error) ===
  environment.etc."gitconfig-root".text = ''
    [safe]
      directory = ${repoPath}
  '';

  # === Daily pull from public repo ===
  systemd.services.pull-updates = {
    description = "Pull changes to system config";
    restartIfChanged = false;
    startAt = "01:00";
    path = [ pkgs.git ];
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

      # Bootstrap if needed
      if [ ! -d ${repoPath}/.git ]; then
        echo "Cloning repository..."
        rm -rf ${repoPath}
        git clone --depth 1 https://github.com/SamIAm789/dotfiles.git ${repoPath}
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