{
  flake.modules.nixos.vps =
  {
    lib,
    ...
  }:
  {
    documentation = {
      enable = false;
      doc.enable = false;
      info.enable = false;
      man.enable = false;
      nixos.enable = false;
    };

    programs.command-not-found.enable = false;

    xdg.autostart.enable = false;

    boot.enableContainers = false;

    services.udisks2.enable = lib.mkForce false;
    services.upower.enable = false;
    services.accounts-daemon.enable = false;

    systemd.coredump.enable = false;
  };
}
