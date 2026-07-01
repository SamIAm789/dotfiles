{
  flake.modules.homeManager.ashell = {

    programs.ashell = {
      enable = true;
      systemd = {
        enable = true;
        #target = "hyprland-session.target";
      };
      settings = {
        outputs = "All";
        position = "Top";
        modules = {
          left = [ "Workspaces" ];
          center = [ "Tempo" ];
          right = [ "Settings" ];
        };
        tempo = {
          format = "%d %b %R";
        };
        appearance = {
          opacity = 0.5;
        };
      };
    };
  };
}
