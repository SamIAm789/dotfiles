{
  self,
  ...
}:
{
  flake.modules.nixos.hermes-vm-host =
  {
    config,
    pkgs,
    ...
  }:
  {
    sops.secrets."hermes-env" = {
      sopsFile = "${self}/secrets/hermes.yaml";
      format = "yaml";
    };

    systemd.services.hermes-env-materialize = {
      description = "Materialize Hermes environment for virtiofs";

      wantedBy = [ "multi-user.target" ];

      after = [ "sops-install-secrets.service" ];
      requires = [ "sops-install-secrets.service" ];

      before = [ "microvm@hermes.service" ];

      serviceConfig = {
        Type = "oneshot";

        ExecStart = pkgs.writeShellScript "hermes-env-materialize" ''
          set -euo pipefail

          src="/run/secrets/hermes-env"
          dst="/run/hermes-secrets/hermes.env"

          if [ ! -f "$src" ]; then
          echo "hermes-env-materialize: $src does not exist" >&2
          exit 1
        fi

        rm -f "$dst"
        cp -- "$src" "$dst"
        chmod 0400 "$dst"
        chown 999:999 "$dst"
        '';
      };
    };
  };
}
