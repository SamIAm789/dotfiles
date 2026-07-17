{

  flake.modules.nixos.opencloud = {


    fileSystems."/persist/data/opencloud" = {
      device = "stuff/opencloud";
      fsType = "zfs";
    };

    services.opencloud = {
      enable = true;
      address = "0.0.0.0";
      url = "https://100.100.0.4:9200";
      port = 9200;
      stateDir = "/persist/data/opencloud";
      environment = {
        OC_INSECURE = "true";
        IDM_ADMIN_PASSWORD = "password";
      };
    };

    networking.firewall.allowedTCPPorts = [ 9200 ];

    preservation.preserveAt."/persist".directories = [
      "/etc/opencloud"
    ];
  };
}
