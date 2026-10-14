{
  flake.modules.nixos.prometheus-server = {

    services.prometheus = {
      enable = true;

      globalConfig = {
        scrape_interval = "60s";
        evaluation_interval = "60s";
      };

      scrapeConfigs = [
        {
          job_name = "node";
          static_configs = [
            {
              targets = [
                "100.100.0.4:9100" #server
                "100.100.0.5:9100" #backup
                "100.100.0.7:9100" #immich
                "100.100.0.52:9100" #thinkpad
              ];
            }
          ];
        }
      ];
    };
  };
}
