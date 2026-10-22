
{
  flake.modules.nixos.crowdsec =
    {
      ...
    }:
    {
      services.crowdsec = {
        enable = true;
        autoUpdateService = true;

        hub.collections = [
          "crowdsecurity/linux"
          "crowdsecurity/sshd"
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

          config.api = {
            server = {
              enable = true;
              listen_uri = "127.0.0.1:8080";

              online_client.credentials_path =
                "/var/lib/crowdsec/data/online_api_credentials.yaml";
            };

            client.credentials_path =
              "/var/lib/crowdsec/data/local_api_credentials.yaml";
          };
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
