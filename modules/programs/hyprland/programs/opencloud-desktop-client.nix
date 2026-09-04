{
  flake.modules.homeManager.opencloud-desktop =
  {
    pkgs,
    ...
  }:
  {
    home.packages = [
      pkgs.opencloud-desktop
    ];

    systemd.user.services.opencloud-desktop = {
      Unit = {
        Description = "OpenCloud Desktop Client";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = "${pkgs.opencloud-desktop}/bin/opencloud";
        Restart = "on-failure";
        RestartSec = 5;
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
