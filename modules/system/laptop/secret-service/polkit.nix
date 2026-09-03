{
  flake.modules.nixos.polkit =
    {
      pkgs,
      ...
    }:
    {

      environment.systemPackages = [
        pkgs.hyprpolkitagent
      ];
      # autostart with systemctl --user enable --now hyprpolkitagent.service

      security.polkit.enable = true;
    };
}
