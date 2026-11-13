{

  flake.modules.nixos.opencloud =
  {
    config,
    pkgs,
    ...
  }:
  {

    fileSystems."/persist/data/opencloud" = {
      device = "stuff/opencloud";
      fsType = "zfs";
    };

            services.caddy.virtualHosts."opencloud.${config.constants.domain}".extraConfig =       ''
      reverse_proxy 127.0.0.1:9200
    '';

    services.opencloud = {
      enable = true;
      package = pkgs.opencloud;
      address = "0.0.0.0";
      url = "https://opencloud.${config.constants.domain}";
      port = 9200;
      stateDir = "/persist/data/opencloud";
      environment = {
        PROXY_TLS = "false";
      };
      environmentFile = config.sops.secrets.opencloud.path;
    };

    preservation.preserveAt."/persist".directories = [
      "/etc/opencloud"
    ];

    sops.secrets.opencloud = {
      owner = "opencloud";
      group = "opencloud";
      mode = "0400";
    };
  };
}
