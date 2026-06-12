{

  flake.modules.nixos.norish =
    {
      config,
      ...
    }:
    let
      containerUser = "containers";
      uid = config.users.users.${containerUser}.uid;
    in
    {

      networking.firewall.allowedTCPPorts = [ 7000 ];

      virtualisation.quadlet = let
        inherit (config.virtualisation.quadlet) pods;
      in {
        pods.norish = {
          autoStart = true;
          rootlessConfig.uid = uid;   # ← Add this
          podConfig = {
            name = "norish";
            publishPorts = ["7000:3000" ];
          };
        };
        containers = {
          norish-app = {
            autoStart = true;
            rootlessConfig.uid = uid;
            serviceConfig = {
              RestartSec = "10";
              Restart = "always";
            };
            unitConfig = {
              After = [
                "norish-db.service"
                "norish-redis.service"
              ];
            };
            containerConfig = {
              image = "docker.io/norishapp/norish:latest";
              pod = "pods.norish.ref";
              # userns = "keep-id";
              user = "1000:1000";
              environments = {
                #  AUTH_URL =  "http://10.25.0.24:7000";
                DATABASE_URL = "postgres://postgres:norish@localhost:5432/norish";
                MASTER_KEY = "EUpSSTvMSV9lj8ISvAbQBh6WCv6XjhBUQfGimLz8jog=";
                CHROME_WS_ENDPOINT = "ws://localhost:3001";
                RECIPES_DISK_DIR = "/app/uploads";
                NEXT_PUBLIC_LOG_LEVEL = "info";
                REDIS_URL = "redis://localhost:6379";
              };
              volumes = [ "/persist/containers/norish/data:/app/uploads" ];
              healthCmd = ''node -e "require('http').get('http://localhost:3000/api/health', r => process.exit(r.statusCode===200?0:1))"'';              healthInterval = "1m";
              healthRetries = 3;
              healthStartPeriod = "1m";
              healthTimeout = "15s";
            };
          };
          norish-db = {
            rootlessConfig.uid = uid;
            containerConfig = {
              name = "norish-db";
              pod = "pods.norish.ref";
              #userns = "keep-id";
              environments = {
                POSTGRES_USER = "postgres";
                POSTGRES_PASSWORD = "norish";
                POSTGRES_DB = "norish";
              };
              image = "docker.io/postgres:18-alpine";
              volumes = [ "/persist/containers/norish/postgres:/var/lib/postgresql/data" ];
            };
            serviceConfig = {
              Restart = "always";
            };
          };
          chrome-headless = {
            rootlessConfig.uid = uid;
            containerConfig = {
              name = "chrome-headless";
              pod = "pods.norish.ref";
              #userns = "keep-id";
              exec = "--no-sandbox --disable-gpu --disable-dev-shm-usage --remote-debugging-address=0.0.0.0 --remote-debugging-port=3001 --headless";
              image = "docker.io/zenika/alpine-chrome:latest";
            };
            serviceConfig = {
              Restart = "always";
            };
          };
          norish-redis = {
            rootlessConfig.uid = uid;
            containerConfig = {
              pod = pods.norish.ref;          # ← Fixed              name = "norish-redis";
              image = "docker.io/redis:8.6.0";
              volumes = [ "/persist/containers/norish/redis:/data" ];
            };
            serviceConfig = {
              Restart = "always";                };
          };
        };
      };
    };
}
