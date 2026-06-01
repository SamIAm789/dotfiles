{
  flake.modules.nixos.skylite =
    {
      config,
      ...
    }:
    let
      containerUid = config.users.users.containers.uid;
    in
    {


    systemd.tmpfiles.rules = [
      "d /persist/containers/skylite/postgres 0750 quadletuser users -"
    ];

    sops.secrets.skylite-env = {
      sopsFile = ./containers.yaml;
      key = "skylite";
      owner = "containers"; # or skylite
    };

    virtualisation.quadlet.pods.skylite = {
      rootlessConfig.uid = containerUid;

      podConfig = {
        publishPorts = [
          "3000:3000"
        ];
      };
    };

    virtualisation.quadlet.containers.skylite-ux-db = {
      rootlessConfig.uid = containerUid;

      containerConfig = {
        image = "docker.io/library/postgres:16";

        pod = "skylite.pod";

        environmentFiles = [
          config.sops.secrets.skylite.path
        ];

        volumes = [
          "/tank/services/skylite/postgres:/var/lib/postgresql/data"
        ];

        healthCmd = "pg_isready -U skylite";
        healthInterval = "10s";
        healthTimeout = "5s";
        healthRetries = 5;
      };

      serviceConfig = {
        Restart = "always";
        RestartSec = "5";
      };
    };

    virtualisation.quadlet.containers.skylite-ux = {
      rootlessConfig.uid = containerUid;

      containerConfig = {
        image = "docker.io/wetzel402/skylite-ux:beta";

        pod = "skylite.pod";

        environmentFiles = [
          config.sops.secrets.skylite.path
        ];

        environments = {
          NUXT_PUBLIC_TZ = "Australia/Brisbane";
          NUXT_PUBLIC_LOG_LEVEL = "warn";
        };
      };

      unitConfig = {
        Requires = [ "skylite-ux-db.service" ];
        After = [ "skylite-ux-db.service" ];
      };

      serviceConfig = {
        Restart = "always";
        RestartSec = "5";
      };
    };
  };
}
