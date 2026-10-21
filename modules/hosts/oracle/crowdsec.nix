{
  flake.modules.nixos.crowdsec =
  {
    config,
    lib,
    ...
  }:
  {

    services.crowdsec = {
      enable = true;
      autoUpdateService = true;
      hub.collections = [
        "crowdsecurity/linux"              # base
        "crowdsecurity/sshd"               # SSH brute-force
        "crowdsecurity/base-http-scenarios"
        "crowdsecurity/http-cve"
      ];



      settings = {
        acquisitions = [
          {
            source = "journalctl";
            journalctl_filter = [ "_SYSTEMD_UNIT=sshd.service" ];
            labels.type = "syslog";
          }
          {
            source = "journalctl";
            journalctl_filter = [ "_TRANSPORT=kernel" ];
            labels.type = "syslog";
          }
        ];
        config.api.server = {
          enable = true;
          listen_uri = "127.0.0.1:8080";
        };

        config.api.client.credentials_path =
          "/var/lib/crowdsec/state/local_api_credentials.yaml";

        config.api.server.online_client.credentials_path =
          "/var/lib/crowdsec/state/online_api_credentials.yaml";
      };
    };
    services.crowdsec-firewall-bouncer = {
      enable = true;
      settings.mode = "nftables";
      settings.api_url = "http://127.0.0.1:8080";
    };

    systemd.services.crowdsec.serviceConfig = {
  DynamicUser = lib.mkForce false;
  PrivateUsers = lib.mkForce false;
};

 systemd.services.crowdsec-firewall-bouncer-register.serviceConfig = {
  DynamicUser = lib.mkForce false;
  User = lib.mkForce "crowdsec";
  Group = lib.mkForce "crowdsec";
  StateDirectory = lib.mkForce "crowdsec-firewall-bouncer-register";
};

    systemd.tmpfiles.rules = [
  "d /var/lib/crowdsec-firewall-bouncer-register 0755 crowdsec crowdsec - -"
  "f /var/lib/crowdsec/state/online_api_credentials.yaml 0600 crowdsec crowdsec - -"
];

    users.users.crowdsec.extraGroups = [ "systemd-journal" ];
  };
}
