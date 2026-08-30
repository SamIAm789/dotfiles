{
  flake.modules.nixos.deploy-rs-update =
  {
    config,
    pkgs,
    ...
  }:
  let
    deployUser = "deploy";
    deployHome = "/var/lib/deploy";
    repoPath = "${deployHome}/dotfiles";
    # … keep your existing lets …
  in
  {
    # … keep user / sops / tmpfiles / flake-update as you have them …

    # deploy-rs needs to be on PATH for the service
    # (or use: inputs.deploy-rs.packages.${pkgs.system}.deploy-rs)
    environment.systemPackages = [ pkgs.deploy-rs ];  # only if you want it system-wide

    systemd.services.flake-deploy = {
      description = "Deploy flake to nodes after lock update";
      # Run only after a successful update job
      after = [ "flake-update.service" ];
      requires = [ "flake-update.service" ];
      # Don’t start at boot by itself — only when update finishes
      # (OnSuccess on the update service is cleaner; see below)

      path = [
        pkgs.git
        pkgs.nix
        pkgs.openssh
        pkgs.coreutils
        pkgs.deploy-rs   # or inputs.deploy-rs.packages.${pkgs.system}.deploy-rs
      ];

      serviceConfig = {
        Type = "oneshot";
        User = deployUser;
        WorkingDirectory = repoPath;
        TimeoutStartSec = "2h";
        # Nice to have if a deploy hangs on SSH
        # Restart = "no";
      };

      environment = {
        HOME = deployHome;
        # Optional: keep deploy-rs from being too chatty / from re-checking
        # NIX_CONFIG = "…";
      };

      script = ''
        set -euo pipefail
        cd ${repoPath}

        # Repo should already be at the commit flake-update left (or pushed).
        # Re-sync in case something else moved main.
        git fetch origin
        git reset --hard origin/main

        # Local build + copy closure + activate (default: not remoteBuild).
        # --skip-checks: you already ran `nix flake check` in flake-update.
        deploy . --skip-checks
      '';
    };

    # Prefer OnSuccess over a separate timer so deploy only runs when
    # the update service actually succeeded.
    systemd.services.flake-update = {
      # merge with your existing flake-update unit
      unitConfig = {
        OnSuccess = [ "flake-deploy.service" ];
      };
    };
  };
}
