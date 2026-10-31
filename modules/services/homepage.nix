{
  flake.modules.nixos.homepage = {
    services.homepage-dashboard = {
      enable = true;
      allowedHosts = "10.25.0.24:8083,100.100.0.10:8083";
      listenPort = 8083;
      openFirewall = true;
      settings = {
        background = "https://images.unsplash.com/photo-1547483238-2cbf881a559f?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=774";
        theme = "dark";
        color = "slate";
        layout = {
          "Networking" = {
            tab = "LAN";
            style = "row";
          };
          "Services" = {
            tab = "LAN";
            style = "row";
          };
          "Server" = {
            tab = "LAN";
            style = "row";
          };
          "Nebula" = {
            tab = "Nebula";
            style = "row";
          };
        };
      };
      services = [
        {
          "Networking" = [
            {
              "ExtremeCloud" = {
                href = "https://sso.extremecloudiq.com";
              };
            }
            {
              "Opnsense" = {
                href = "http://10.25.0.1";
              };
            }
          ];
        }
        {
          "Services" = [
            {
              "Home Assistant" = {
                description = "Home automation platform";
                href = "http://10.25.0.31:8123";
              };
            }
            {
              "Immich" = {
                description = "Photo album";
                href = "http://10.25.0.24:2284";
              };
            }
            {
              "KitchenOwl" = {
                description = "Recipes and shopping lists";
                href = "http://10.25.0.24:8082";
              };
            }
            {
              "Own Cloud" = {
                description = "File sharing";
                href = "https://10.25.0.24:9200";
              };
            }
            {
              "Paperless" = {
                description = "Document management";
                href = "http://10.25.0.24:28981";
              };
            }
            {
              "Pinchflat" = {
                description = "youtube downloader";
                href = "http://10.25.0.24:8945";
              };
            }
            {
              "Stirling PDF Editor" = {
                href = "http://10.25.0.24:8080";
              };
            }
            {
              "TWC Manager" = {
                description = "Car charging";
                href = "http://10.25.0.30:8080";
              };
            }
            {
              "Jellyfin" = {
                description = "Media server";
                href = "http://10.25.0.24:8096";
              };
            }
            {
              "Pinchflat" = {
                description = "YouTube download management";
                href = "http://10.25.0.24:8945";
              };
            }
          ];
        }
        {
          "Nebula" = [
            {
              "Home Assistant" = {
                description = "Home automation platform";
                href = "http://100.100.0.6:8123";
              };
            }
            {
              "Immich" = {
                description = "Photo album";
                href = "http://100.100.0.10:2284";
              };
            }
            {
              "KitchenOwl" = {
                description = "Recipes and shopping lists";
                href = "http://100.100.0.10:8082";
              };
            }
            {
              "Own Cloud" = {
                description = "File sharing";
                href = "https://100.100.0.10:9200";
              };
            }
            {
              "Paperless" = {
                description = "Document management";
                href = "http://100.100.0.10:28981";
              };
            }
            {
              "Stirling PDF Editor" = {
                href = "http://100.100.0.10:8080";
              };
            }
            {
              "TWC Manager" = {
                description = "Car charging";
                href = "http://100.100.0.10:8080";
              };
            }
            {
               "Incus" = {
                 href = "https://100.100.0.4:8443";
               };
            }
            {
              "Jellyfin" = {
                description = "Media server";
                href = "http://100.100.0.10:8096";
              };
            }
            {
              "Pinchflat" = {
                description = "YouTube download management";
                href = "http://100.100.0.10:8945";
              };
            }
          ];
        }
        {
           "Server" = [
             {
               "Cockpit" = {
                 href = "http://10.25.0.24:9090";
               };
             }
             {
               "Incus" = {
                 href = "https://10.25.0.24:8443";
               };
             }
           ];
         }
       ];
    };
  };
}
