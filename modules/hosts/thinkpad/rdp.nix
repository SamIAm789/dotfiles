{
  flake.modules.nixos.thinkpad = {

    services.gnome.gnome-remote-desktop.enable = true;
    systemd.services.gnome-remote-desktop = { 
      wantedBy = [ "graphical.target" ];
    };
    # services.displayManager.autoLogin.enable = false;
    networking.firewall.allowedTCPPorts = [ 3389 ];
  };
}
