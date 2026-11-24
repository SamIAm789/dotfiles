{
  flake.modules.nixos.dbus = {
    services.dbus.implementation = "broker";
  };
}
