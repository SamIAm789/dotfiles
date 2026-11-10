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
      url = "https://100.100.0.10:9200";
      port = 9200;
      stateDir = "/persist/data/opencloud";
      environment = {
        OC_INSECURE = "true";
      };
      environmentFile = config.sops.secrets.opencloud.path;
    };

    networking.firewall.allowedTCPPorts = [ 9200 ];

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
