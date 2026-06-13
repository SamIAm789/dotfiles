{
  inputs,
  ...
}:
{
  flake.modules.nixos.norish-hm =
  {
    config,
    ...
  }:
  let
    geminiKeyPath =
      config.sops.secrets."gemini-api-key-samblack".path;
  in
  {
    networking.firewall.allowedTCPPorts = [ 7000 ];

    sops.secrets."gemini-api-key-samblack" = {
      sopsFile = "${inputs.secrets}/secrets/secrets.yaml";
     # key = "gemini-api-key-samblack";
      owner = config.users.users.sam.name;
      group = "users";
      mode = "0400";
    };

    home-manager.users.sam = { pkgs, config, ... }: {

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
                AUTH_URL =  "http://100.100.0.4:7000";
                DATABASE_URL = "postgres://postgres:norish@localhost:5432/norish";
                MASTER_KEY = "EUpSSTvMSV9lj8ISvAbQBh6WCv6XjhBUQfGimLz8jog=";
                CHROME_WS_ENDPOINT = "ws://127.0.0.1:3001";
                UPLOADS_DIR = "/app/uploads";
                NEXT_PUBLIC_LOG_LEVEL = "info";
                REDIS_URL = "redis://localhost:6379";
                RECIPE_RENDERER= "chrome";
                AI_ENABLED = "true";
                AI_PROVIDER = "openai";
                AI_BASE_URL = "https://generativelanguage.googleapis.com/v1beta/openai/";
                AI_MODEL = "gemini-1.5-pro";
                AI_API_KEY = builtins.readFile geminiKeyPath;
              };
              volumes = [ "/persist/containers/norish/data:/app/uploads" ];
              #healthCmd = ''
              #node -e "require('http').get('http://localhost:3000/api/v1/health', r => process.exit(r.statusCode===200?0:1))"
              #'';              healthInterval = "1m";
              #healthRetries = 3;
              #healthStartPeriod = "1m";
              #healthTimeout = "15s";
            };
          };
          norish-db = {
            containerConfig = {
              name = "norish-db";
              pod = "norish.pod";
              #userns = "keep-id";
              environments = {
                POSTGRES_USER = "postgres";
                POSTGRES_PASSWORD = "norish";
                POSTGRES_DB = "norish";
              };
              image = "docker.io/postgres:17-alpine";
              volumes = [ "/persist/containers/norish/postgres:/var/lib/postgresql/data" ];
            };
            serviceConfig = {
              Restart = "always";
            };
          };
          chrome-headless = {
            containerConfig = {
              name = "chrome-headless";
              pod = "norish.pod";
              exec = [
                "chromium-browser"
                "--no-sandbox"
                "--disable-setuid-sandbox"
                "--disable-gpu"
                "--disable-dev-shm-usage"
                "--remote-debugging-address=0.0.0.0"
                "--remote-debugging-port=3001"
                "--headless"
              ];
              image = "docker.io/zenika/alpine-chrome:latest";
            };
            serviceConfig = {
               Restart = "always";
            };
          };
          norish-redis = {
            containerConfig = {
              pod = "norish.pod";
              name = "norish-redis";
              #userns = "keep-id";
              image = "docker.io/redis:8.6.0";
              volumes = [ "/persist/containers/norish/redis:/data" ];
            };
            serviceConfig = {
              Restart = "always";
            };
          };
        };
      };
    };
  };
}
