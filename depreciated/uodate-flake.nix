{
  flake.modules.nixos.update-flake-old =
  {
    pkgs,
    ...
  }:
  let
    repoDir = "/home/sam/dotfiles";
    serviceName = "update-flake-lock";
  in
  {

    systemd.services.${serviceName} = {
      description = "Update flake.lock and push changes";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      restartIfChanged = false;

      path = with pkgs; [
        git
        nix
        openssh
      ];

      script = ''
        set -euo pipefail

        cd ${repoDir}

        # Ensure we are on main
        test "$(git branch --show-current)" = "main"

        # Pull latest changes
        git pull --ff-only

        # Update flake.lock
        nix flake update

        # Validate the flake
        nix flake check

        # If no changes, exit cleanly
        git diff --quiet flake.lock && exit 0

        # Commit and push
        git add flake.lock
        git commit -m "flake.lock: automatic update" || exit 0
        git push
      '';

      serviceConfig = {
        WorkingDirectory = repoDir;
        User = "sam";
        Type = "oneshot";
      };

      # Run nightly at 00:30
      startAt = "00:30";
    };
  };
}
