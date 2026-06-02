{
  flake.modules.nixos.autoupdate =
  {
    pkgs,
    ...
  }:
  {
    systemd.services.pull-updates = {
      description = "Pulls changes to system config";
      restartIfChanged = false;
      startAt = "01:00";
      path = [ pkgs.git pkgs.openssh ];
      script = ''
        test "$(git branch --show-current)" = "main"
        git pull --ff-only
      '';
      serviceConfig = {
        WorkingDirectory = "/home/sam/dotfiles";
        User = "sam";
        Type = "oneshot";
      };
    };

    system.autoUpgrade = {
      enable = true;
      flake = "path:/home/sam/dotfiles/";
      allowReboot = true;
      rebootWindow = {
        lower = "02:00";
        upper = "04:00";
      };
    };
  };
}
