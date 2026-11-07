{
  flake.module.nixos.deploy-to-targets =
  {
    pkgs,
    ...
  }:
  let
    deploymentTargets = [
      "oracle"
      "backup"
    ];

    deployCommands = pkgs.lib.concatMapStringsSep "\n"       (target: ''
  deploy ${target}
'') deploymentTargets;
  {

    
     systemd.services.oracle-deploy = {
       description = "Deploy latest NixOS configuration to Oracle VPS";

       requires = [ "flake-update.service" ];
       after = [
        "network-online.target"
        "flake-update.service"
       ];

       wants = [ "network-online.target" ];

       path = [
         pkgs.nix
         pkgs.openssh
         pkgs.git
         pkgs.coreutils
       ];

       serviceConfig = {
         Type = "oneshot";
         User = "deploy-rs";
         Group = "deploy-rs";
         WorkingDirectory = "/var/lib/deploy-rs";
         TimeoutStartSec = "2h";
       };

       environment = {
         HOME = "/var/lib/deploy-rs";
         XDG_CACHE_HOME = "/var/lib/deploy-rs/.cache";
       };

  
       script = ''
         set -uo pipefail

         failures=0

         deploy() {
           local target="$1"

           echo   "========================================"
           echo "Deploying $target..."
           echo   "========================================"

           if nix run nixpkgs#deploy-rs -- \
             --skip-checks \
             "github:SamIAm789/dotfiles#$target" \
             -- --refresh
           then
             echo "SUCCESS: $target"
           else
             result=$?
             echo "FAILED: $target (exit code $result)"
             failures=$((failures + 1))
           fi
         }

         deploy oracle
         deploy backup

         echo   "========================================"
         echo "Deployment summary"
         echo   "========================================"

         if [ "$failures" -gt 0 ]; then
           echo "$failures deployment(s) failed."
           exit 1
         fi

         echo "All deployments completed successfully."
       '';

      };
    };
  };
}