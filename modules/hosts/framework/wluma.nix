{
  flake.modules.homeManager.wluma-framework = {

    services.wluma.settings = {

        output.backlight = [
          {
            name = "eDP-1";
            path = "/sys/class/backlight/intel_backlight";
            capturer = "none";
          }
        ];
      };
    };
}
