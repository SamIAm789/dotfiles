{
  inputs,
  ...
}:
{
  flake.modules.nixos.norish-hm = {

    networking.firewall.allowedTCPPorts = [ 7000 ];

    home-manager.users.sam = {

      imports = [ inputs.quadlet-nix.homeManagerModules.quadlet ];

        virtualisation.quadlet = {
          pods.norish = {
            autoStart = true;
            podConfig = {
              name = "norish";
              publishPorts = ["7000:3000" ];
            };
          };
          containers = {
            norish-app = {
              autoStart = true;
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
                pod = "norish.pod";
               # userns = "keep-id";
                user = "1000";
                group = "1000";
                environments = {
                #  AUTH_URL =  "http://10.25.0.24:7000";
                  DATABASE_URL = "postgres://postgres:norish@localhost:5432/norish";
                  MASTER_KEY = "EUpSSTvMSV9lj8ISvAbQBh6WCv6XjhBUQfGimLz8jog=";
                  CHROME_WS_ENDPOINT = "ws://localhost:3001";
                  RECIPES_DISK_DIR = "/app/uploads";
                  NEXT_PUBLIC_LOG_LEVEL = "info";
                  REDIS_URL = "redis://localhost:6379";
                  };
                volumes = [ "norish_data:/app/uploads" ];
                healthCmd = ''=node -e "require('http').get('http://localhost:3000/api/health', r => process.exit(r.statusCode===200?0:1)'';
                healthInterval = "1m";
                healthRetries = 3;
                healthStartPeriod = "1m";
                healthTimeout = "15s";
              };
            };
            db = {
              containerConfig = {
                name = "norish-db";
                pod = "norish.pod";
                #userns = "keep-id";
                environments = {
                  POSTGRES_USER = "postgres";
                  POSTGRES_PASSWORD = "norish";
                  POSTGRES_DB = "norish";
                };
                image = "docker.io/postgres:18-alpine";
                volumes = [ "norish_db_data:/var/lib/postgresql/data" ];
              };
              serviceConfig = {
                Restart = "always";
              };
            };
            chrome-headless = {
              containerConfig = {
                name = "chrome-headless";
                pod = "norish.pod";
                #userns = "keep-id";
                exec = "--no-sandbox --disable-gpu --disable-dev-shm-usage '--remote-debugging-address=0.0.0.0' '--remote-debugging-port=3001' --headless";
                image = "docker.io/zenika/alpine-chrome:latest";
              };
              serviceConfig = {
                 Restart = "always";
              };
            };
            redis = {
              containerConfig = {
                pod = "norish.pod";
                name = "norish-redis";
                #userns = "keep-id";
                image = "docker.io/redis:8.6.0";
                volumes = [ "norish_redis_data:/data" ];
              };
              serviceConfig = {
                Restart = "always";                };
              };
            };
        };
    };
  };
}
