{
  flake.modules.homeManager.wluma = {

    services.wluma = {
      enable = true;

      settings = {

        output.backlight = [
          {
            name = "eDP-1";
            path = "/sys/class/backlight/intel_backlight";
            capturer = "none";
          }
        ];
      };
    };
  };
}
