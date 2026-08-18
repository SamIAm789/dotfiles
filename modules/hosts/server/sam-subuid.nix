{
  flake.modules.nixos.server = {
    environment.etc."subuid" = {
      text = ''
        sam:100000:65536
      '';
      mode = "0444";
    };

    environment.etc."subgid" = {
      text = ''
        sam:100000:65536
      '';
      mode = "0444";
    };
  };
}
