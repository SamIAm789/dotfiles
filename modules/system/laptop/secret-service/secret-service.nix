{
  flake.modules.nixos.secret-service = {
    security.pam.services.login.enableGnomeKeyring = true;
    services.gnome = {
      gnome-keyring.enable = true;
      gcr-ssh-agent.enable = false;
    };
  };
}
