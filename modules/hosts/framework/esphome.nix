
{
  flake.modules.nixos.esphome =
    { lib, pkgs, ... }:
    {
      services.esphome = {
        enable = true;
        allowedDevices = [
          "char-ttyUSB"
          "char-ttyS"
        ];
      };

      systemd.services.esphome.serviceConfig.ExecStart =
        lib.mkForce
          "${pkgs.esphome-device-builder}/bin/esphome-device-builder --host 127.0.0.1 /var/lib/esphome";

      programs.firefox = {
        policies = {
          DefaultSerialGuardSetting = 3;
          Preferences = {
            "dom.webserial.enabled" = true;
          };
        };
      };

      users.users.sam.extraGroups = [ "dialout" ];
    };
}
