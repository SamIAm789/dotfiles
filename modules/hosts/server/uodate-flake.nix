{
  flake.modules.nixos.server =
  {
    pkgs,
    ...
  }:
  {
    systemd.services.update-flake-lock = {
      description = "Update flake.lock and push";
      restartIfChanged = false;

      path = with pkgs; [
        git
        nix
        openssh
      ];

      script = ''
        set -euo pipefail
        git pull --ff-only
        nix flake update
        nix flake check
        git diff --quiet flake.lock && exit 0
        git add flake.lock
        git commit -m "flake.lock: automatic update" || exit 0
        git push
       '';

       serviceConfig = {
         WorkingDirectory = "/home/sam/dotfiles";
         User = "sam";
         Type = "oneshot";
       };

       startAt = "00:30";
     };
   };
}
