{
  flake.modules.nixos.sanoid = {
    services.sanoid = {

      enable = true;
      templates = {
        production = {
          hourly = 24;
          weekly = 30;
          monthly = 3;
          yearly = 0;
          autosnap = true;
          autoprune = true;
        };
        backup = {
          autoprune = true;
          frequently = 0;
          hourly = 30;
          daily = 90;
          monthly = 12;
          yearly = 0;
          autosnap = false;
        };
      };
    };
  };
}
