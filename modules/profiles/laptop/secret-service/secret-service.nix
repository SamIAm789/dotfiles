{
  flake.modules.nixos.secret-service =
  {
    pkgs,
    ...
  }:
  {
    security.pam.services.login.enableGnomeKeyring = true;
    services.gnome = {
      gnome-keyring.enable = true;
      gcr-ssh-agent.enable = false;
    };
    environment.systemPackages = with pkgs; [
      libsecret
    ];
  };
}
