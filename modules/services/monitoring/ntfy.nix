{
  flake.modules.nixos.prometheus-server = {

    services.prometheus.alertmanager = {
      enable = true;

      configuration = {
        route = {
          receiver = "ntfy";
          group_by = [ "alertname" "instance" ];
          group_wait = "30s";
          group_interval = "5m";
          repeat_interval = "4h";
        };

        receivers = [
          {
            name = "ntfy";

            webhook_configs = [
              {
                # Replace this with your actual self-hosted ntfy URL.
                url = "http://100.100.0.4:/monitoring-alerts?template=alertmanager";
                send_resolved = true;
              }
            ];
          }
        ];
      };
    };
  };
}
