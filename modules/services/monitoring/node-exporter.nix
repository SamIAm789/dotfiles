{
  flake.modules.nixos.prometheus-exporter = {

    services.prometheus.exporters.node = {
      enable = true;
      port = 9101;
      listenAddress = "0.0.0.0";
      openFirewall = true;

      enabledCollectors = [
        "systemd"
      ];
    };
  };
}
