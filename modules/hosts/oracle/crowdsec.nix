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

        lapi.credentialsFile =
  "/var/lib/crowdsec/data/.local_api_credentials.yaml";
        capi.credentialsFile =
  "/var/lib/crowdsec/data/online_api_credentials.yaml";
      };
    };
    services.crowdsec-firewall-bouncer = {
      enable = true;
      settings.mode = "nftables";
      settings.api_url = "http://127.0.0.1:8080";
    };

    users.users.crowdsec.extraGroups = [ "systemd-journal" ];
  };
}
