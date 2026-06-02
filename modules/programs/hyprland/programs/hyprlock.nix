{
  flake.modules.nixos.hyprlock =
  {
    pkgs,
    ...
  }:
  {
    security.pam.services.hyprlock = {};
    environment.systemPackages = with pkgs; [ hyprlock ];
  };

  flake.modules.homeManager.hyprlock = {
    programs.hyprlock = {

        enable = true;
        settings = {
          general = {
            hide_cursor = true;
          };

          auth = {
            fingerprint = {
              enabled = true;
              ready_message = "Scan fingerprint";
              present_message = "Scanning...";
              retry_delay = "250";
            };
          };

          animations = {
            enabled = true;
            fade_in = {
              duration = 300;
              bezier = "easeOutQuint";
            };
            fade_out = {
              duration = 300;
              bezier = "easeOutQuint";
            };
          };

          background = [
            {
              path = "screenshot";
              blur_passes = 3;
              blue_size = 8;
            }
          ];

          input-field = [
            {
              size = "200, 50";
              position = "0, -80";
              monitor = "";
              dots_center = true;
              fade_on_empty = false;
              font_color = "rgb(202, 211, 245)";
              inner_color = "rgb(91, 96, 120)";
              outer_color = "rgb(24, 25, 38)";
              outline_thickness = 5;
              placeholder_text = "'\'Password...'\'";
              shadow_passes = 2;
            }
          ];
        };
      };
    };
}
