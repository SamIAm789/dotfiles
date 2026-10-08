{
  flake.modules.nixos.crowdsec =
  {
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

      localConfig.acquisitions = [
        {
          source = "journalctl";
          journalctl_filter = [ "_SYSTEMD_UNIT=sshd.service" ];
          labels.type = "syslog";
        }
        # Optional – kernel / firewall drops
        {
          source = "journalctl";
          journalctl_filter = [ "_TRANSPORT=kernel" ];
          labels.type = "syslog";
        }
      ];

      settings = {
        general = {
          api.server = {
            enable = true;
            listen_uri = "127.0.0.1:8080";
          };
        };
        lapi.credentialsFile = "/var/lib/crowdsec/state/local_api_credentials.yaml";
        capi.credentialsFile = "/var/lib/crowdsec/state/online_api_credentials.yaml";
      };
    };
    services.crowdsec-firewall-bouncer = {
      enable = true;
      settings.mode = "nftables";
      settings.api_url = "http://127.0.0.1:8080";
    };

    systemd.services.crowdsec.serviceConfig.PrivateUsers = lib.mkForce false;

    systemd.services.crowdsec-firewall-bouncer-register.serviceConfig = {
  DynamicUser = lib.mkForce false;
  StateDirectory = lib.mkForce "crowdsec-firewall-bouncer-register";
};

    users.users.crowdsec.extraGroups = [ "systemd-journal" ];
  };
}
