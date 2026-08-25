{
  flake.modules.nixos.server = {
    environment.etc."subuid" = {
      text = ''
        sam:100000:65536
      '';
      mode = "0644";
    };

    environment.etc."subgid" = {
      text = ''
        sam:100000:65536
      '';
      mode = "0644";
    };
  };
  # needed due to userborn not passing user.user.sam.autosubuidgid along
}
