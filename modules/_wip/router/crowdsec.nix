{
  flake.modules.nixos.router = {

    services.crowdsec = {
      enable = true;
      autoUpdateService = true;

      settings = {
        general = {
          api.server = {
            enable = true;
            listen_uri = "127.0.0.1:8080";
          };
          # Credentials files (created automatically)
          lapi.credentialsFile = "/var/lib/crowdsec/state/local_api_credentials.yaml";
        };
      };

      # Collections useful on a router
      hub.collections = [
        "crowdsecurity/linux"           # base
        "crowdsecurity/sshd"            # SSH brute-force
        "crowdsecurity/iptables"        # firewall / kernel drops
        "crowdsecurity/http-cve"        # common HTTP attacks (if you ever run a web service)
        "crowdsecurity/base-http-scenarios"
      ];

      # What logs to watch
      localConfig.acquisitions = [
        # SSH
        {
          source = "journalctl";
          journalctl_filter = [ "_SYSTEMD_UNIT=sshd.service" ];
          labels.type = "syslog";
        }
        # Kernel / firewall drops (useful with nftables)
        {
          source = "journalctl";
          journalctl_filter = [ "_TRANSPORT=kernel" ];
          labels.type = "syslog";
        }
        # Optional: dnsmasq logs if you enable query logging
        # {
        #   source = "journalctl";
        #   journalctl_filter = [ "_SYSTEMD_UNIT=dnsmasq.service" ];
        #   labels.type = "syslog";
        # }
      ];
    };

    services.crowdsec-firewall-bouncer = {
      enable = true;

      settings = {
        # Uses nftables automatically when networking.nftables.enable = true
        mode = "nftables";
        api_url = "http://127.0.0.1:8080";
      };
    };

    ##########################################################################
    # Small work-arounds that are still needed on current nixpkgs
    ##########################################################################
    # Ensure state directory exists with correct ownership
    systemd.tmpfiles.rules = [
      "d /var/lib/crowdsec 0755 crowdsec crowdsec -"
      "d /var/lib/crowdsec/state 0755 crowdsec crowdsec -"
    ];

    # Journal access fix (PrivateUsers + systemd-journal group)
    systemd.services.crowdsec.serviceConfig = {
      SupplementaryGroups = [ "systemd-journal" ];
      # If the journal acquisition still dies, uncomment the next line:
      # PrivateUsers = lib.mkForce false;
    };
  };
}
