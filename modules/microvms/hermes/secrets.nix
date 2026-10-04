{
  self,
  ...
}:
{
  flake.modules.nixos.hermes =
    {
      config,
      pkgs,
      ...
    }:
    {
      sops.secrets."hermes-env" = {
        sopsFile = "${self}/secrets/hermes.yaml";
      };

      services.hermes-agent.environmentFiles = [
        config.sops.secrets."hermes-env".path
      ];

      systemd.services.hermes-env-materialize = {
        description = "Materialize Hermes environment";

        wantedBy = [ "multi-user.target" ];

        after = [
          "sops-install-secrets.service"
        ];

        requires = [
          "sops-install-secrets.service"
        ];

        before = [
          "hermes-agent.service"
        ];

        serviceConfig = {
          Type = "oneshot";

          ExecStart = pkgs.writeShellScript "hermes-env-materialize" ''
            set -eu

            install -m 0640 \
              ${config.sops.secrets."hermes-env".path} \
              /var/lib/hermes/.hermes/.env

            chown hermes:hermes /var/lib/hermes/.hermes/.env
          '';
        };
      };

      systemd.services.hermes-agent = {
        requires = [ "hermes-env-materialize.service" ];
        after = [ "hermes-env-materialize.service" ];
      };
    };
}
