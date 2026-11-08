
{
  flake.modules.nixos.server =
    {
      pkgs,
      ...
    }:
    {
      systemd.services.deploy-all = {
        description = "Deploy latest NixOS configuration to targets";

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
          pkgs.jq
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

          flakeRef="github:SamIAm789/dotfiles"

          echo "========================================"
          echo "Discovering deployment targets..."
          echo "========================================"

          if ! targets=$(nix eval \
            --json \
            "$flakeRef#deploy.nodes" \
            --apply builtins.attrNames |
            jq -er '
              if type == "array" and length > 0
              then .[]
              else error("No deployment nodes found")
              end
            ')
          then
            echo "ERROR: Failed to discover deployment targets."
            exit 1
          fi

          mapfile -t deploymentTargets <<< "$targets"

          echo "Found ${"$"}{#deploymentTargets[@]} deployment target(s):"
          printf '  - %s\n' "''${deploymentTargets[@]}"

          failures=0

          deploy() {
            local target="$1"

            echo "========================================"
            echo "Deploying $target..."
            echo "========================================"

            if nix run nixpkgs#deploy-rs -- \
              --skip-checks \
              "$flakeRef#$target" \
              -- --refresh
            then
              echo "SUCCESS: $target"
            else
              result=$?
              echo "FAILED: $target (exit code $result)"
              failures=$((failures + 1))
            fi
          }

          for target in "''${deploymentTargets[@]}"; do
            deploy "$target"
          done

          echo "========================================"
          echo "Deployment summary"
          echo "========================================"

          if [ "$failures" -gt 0 ]; then
            echo "$failures deployment(s) failed."
            exit 1
          fi

          echo "All deployments completed successfully."
        '';
      };

      systemd.timers.deploy-all = {
        description = "Daily NixOS deployment";

        wantedBy = [ "timers.target" ];

        timerConfig = {
          OnCalendar = "12:00";
          Persistent = true;
          RandomizedDelaySec = "15m";
        };
      };
    };
}
