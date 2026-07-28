{

  flake.modules.nixos.opencloud =
  {
    config,
    ...
  }:
  {

    fileSystems."/persist/data/opencloud" = {
      device = "stuff/opencloud";
      fsType = "zfs";
    };

    services.opencloud = {
      enable = true;
      address = "0.0.0.0";
      url = "http://100.100.0.4:9200";
      port = 9200;
      stateDir = "/persist/data/opencloud";
      environment = {
        OC_INSECURE = "true";
        IDM_ADMIN_PASSWORD_FILE = config.sops.secrets.opencloud.path;
      };
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
