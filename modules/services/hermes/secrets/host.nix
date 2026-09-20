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
      path = "/run/hermes-secrets/hermes.env";
      mode = "0440";
    };

    sops.templates."hermes.env" = {
      path = "/run/hermes-secrets/hermes.env";
      content = config.sops.placeholder."hermes-env";
      mode = "0440";
    };

    systemd.tmpfiles.rules = [
      "d /run/hermes-secrets 0750 root microvm -"
    ];

    systemd.services.hermes-env-materialize = {
      description = "Materialize Hermes environment for virtiofs";

      before = [
        "microvm@hermes.service"
      ];

      serviceConfig = {
        Type = "oneshot";

        ExecStart = pkgs.writeShellScript "hermes-env-materialize" ''
          set -euo pipefail

          src="/run/secrets/rendered/hermes.env"
          dst="/run/hermes-secrets/hermes.env"

          if [ ! -f "$src" ]; then
          echo "hermes-env-materialize: $src does not exist" >&2
          exit 1
          fi

          rm -f "$dst"
          cp -- "$src" "$dst"
          chmod 0440 "$dst"
          chown root:microvm "$dst"
        '';
      };
    };
  };
}
