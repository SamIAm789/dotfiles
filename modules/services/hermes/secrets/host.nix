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

    systemd.tmpfiles.rules = [
      "d /run/hermes-secrets 0750 root microvm -"
    ];

    sops.templates."hermes.env" = {
      path = "/run/hermes-secrets/hermes.env";
      content = config.sops.placeholder."hermes-env";
      mode = "0440";
    };

    systemd.services.hermes-env-materialize = {
      description = "Copy rendered hermes.env into virtiofs share";
      wantedBy = [ "multi-user.target" ];
      after = [ "sops-nix.service" ];
      before = [ "microvm@hermes.service" ];  # adjust unit name
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = pkgs.writeShellScript "hermes-env-materialize" ''
          set -euo pipefail
          mkdir -p /run/hermes-secrets
          src="/run/secrets/rendered/hermes.env"
          dst="/run/hermes-secrets/hermes.env"
          if [ -f "$src" ]; then
            cp -f "$src" "$dst"
            chmod 0440 "$dst"
            chown root:root "$dst"
          fi
        '';
      };
    };
  };
}
