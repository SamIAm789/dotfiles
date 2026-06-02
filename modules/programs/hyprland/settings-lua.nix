{
  flake.modules.homeManager.hyprland = {

    wayland.windowManager.hyprland = {
      enable = true;
      package = null;
      portalPackage = null;
      systemd.enable = false; # uwsm compatibility
      configType = "lua";
    };

    xdg.configFile."hypr/hyprland.lua".source = ./hyprland.lua;
  };
}
