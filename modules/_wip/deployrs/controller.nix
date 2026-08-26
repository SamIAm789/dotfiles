# modules/profiles/server/deploy-controller.nix  (only on the controller)
{ config, pkgs, lib, ... }:
let
  deployUser = "deploy";
  deployHome = "/var/lib/deploy";
  repoPath = "${deployHome}/dotfiles";
in
{
  # Reuse / extend the deploy user
  users.users.${deployUser} = {
    isNormalUser = true;
    home = deployHome;
    createHome = true;
    hashedPassword = "!";
    openssh.authorizedKeys.keys = [
      # key you use when SSHing *to* this host (optional)
    ];
  };

  # SSH key the controller uses to talk to the other hosts
  # Prefer sops-nix for the private key
  sops.secrets."deploy-controller-key" = {
    owner = deployUser;
    path = "${deployHome}/.ssh/id_ed25519";
  };

  environment.etc."deploy-ssh-config" = {
    text = ''
      Host server backup thinkpad
        User deploy
        IdentityFile ${deployHome}/.ssh/id_ed25519
        IdentitiesOnly yes
        StrictHostKeyChecking accept-new
    '';
    mode = "0644";
  };

  systemd.tmpfiles.rules = [
    "d ${deployHome} 0750 ${deployUser} ${deployUser} -"
    "d ${deployHome}/.ssh 0700 ${deployUser} ${deployUser} -"
    "d ${repoPath} 0750 ${deployUser} ${deployUser} -"
  ];

  # Nightly: pull latest flake, then push with deploy-rs
  systemd.services.deploy-fleet = {
    description = "Pull flake and deploy to fleet with deploy-rs";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    path = with pkgs; [ git openssh nix deploy-rs ];  # or nix run github:serokell/deploy-rs
    serviceConfig = {
      Type = "oneshot";
      User = deployUser;
      WorkingDirectory = repoPath;
      Environment = [
        "HOME=${deployHome}"
        "GIT_SSH_COMMAND=ssh -F /etc/deploy-ssh-config"
        "NIX_SSHOPTS=-F /etc/deploy-ssh-config"
      ];
    };
    script = ''
      set -euo pipefail

      if [ ! -d ${repoPath}/.git ]; then
        git clone https://github.com/SamIAm789/dotfiles.git ${repoPath}
      fi

      cd ${repoPath}
      git fetch origin
      git reset --hard origin/main

      # Push to the other hosts (exclude self if controller is also a node)
      deploy --targets \
        .#backup \
        .#thinkpad \
        # .#server   # skip if this machine *is* server
    '';
  };

  systemd.timers.deploy-fleet = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "02:30";          # after any auto-upgrade window if you keep both
      Persistent = true;
      RandomizedDelaySec = "15min";
    };
  };
}
