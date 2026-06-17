{

  flake.modules.nixos.opencloud = {

    services.opencloud = {
      enable = true;
      address = "0.0.0.0";
      url = "https://100.100.0.4:9200";
      port = 9200;
      stateDir = "/stuff/opencloud";
      environment = {
        OC_INSECURE = "true";
        IDM_ADMIN_PASSWORD = "password";
      };
    };

    networking.firewall.allowedTCPPorts = [ 9200 ];
  };
}
