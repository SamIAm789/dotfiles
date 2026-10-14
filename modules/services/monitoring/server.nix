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
                "100.100.0.4:9101" #server
                "100.100.0.5:9101" #backup
                "100.100.0.7:9101" #immich
                "100.100.0.52:9101" #thinkpad
              ];
            }
          ];
        }
      ];
      networking.firewall.allowedTCPPorts = [
        9090
      ];
    };
  };
}
