{
  flake.modules.nixos.crowdsec = {

    services.crowdsec = {
      enable = true;
      autoUpdateService = true;   # daily `cscli hub update`

      # Install useful collections
      hub.collections = [
        "crowdsecurity/linux"              # base
        "crowdsecurity/sshd"               # SSH brute-force
        "crowdsecurity/base-http-scenarios"
        "crowdsecurity/http-cve"
      # Add more as needed, e.g.:
      # "crowdsecurity/nginx"
      # "crowdsecurity/caddy"
      # "crowdsecurity/whitelist-good-actors"
      ];

      # What logs to watch (journald is the cleanest on NixOS)
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
      # Add more units if you run nginx/caddy/etc.
      ];

      # Make sure the local API is enabled
      settings.general = {
        api.server = {
          enable = true;
          listen_uri = "127.0.0.1:8080";
        };
      };
    };
  };
}

  # Firewall bouncer (blocks the IPs CrowdSec decides on)
  services.crowdsec-firewall-bouncer = {
    enable = true;
    # mode defaults sensibly; force nftables if you use networking.nftables.enable = true
    # settings.mode = "nftables";   # or "iptables"
    settings.api_url = "http://127.0.0.1:8080";
  };

  # Helpful for journal access (sometimes needed)
  users.users.crowdsec.extraGroups = [ "systemd-journal" ];
}