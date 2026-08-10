{
  flake.modules.nixos.paperless = {

    services.paperless = {
        enable = true;
        consumptionDirIsPublic = true;
        dataDir = "/stuff/paperless";
        passwordFile = "/etc/paperless-admin-pass";
        address = "0.0.0.0";
        domain = "home.local";
        settings.PAPERLESS_AUTO_LOGIN_USERNAME = "admin";
    };

    environment.etc."paperless-admin-pass".text = "admin"; # TODO change this to sops

    networking.firewall.allowedTCPPorts = [ 28981 ];
  };
}
