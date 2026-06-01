{
  flake.modules.nixos.haos = 
  {
    lib,
    pkgs,
    ...
  }:

  let
    mkMac = vmName: let
      hash = builtins.hashString "sha256" vmName;
    in
      "02:" +
      builtins.substring 0 2 hash + ":" +
      builtins.substring 2 2 hash + ":" +
      builtins.substring 4 2 hash + ":" +
      builtins.substring 6 2 hash + ":" +
      builtins.substring 8 2 hash;

      mac = mkMac "haos";
  in
  {

    networking.interfaces."vm-haos" = {
      virtual = true;
      virtualType = "tap";
      virtualOwner = "root";
    };

   # ? networking.bridges.microbr.interfaces = [ "vm-haos" ];

    systemd.services.haos-vm = {
      description = "Home Assistant OS VM (Cloud-Hypervisor)";
      after = [
        "network-online.target"
        "network-addresses-vm-haos.service"
      ];
      wants = [
        "network-online.target"
        "network-addresses-vm-haos.service"
      ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        Restart = "on-failure";
        RestartSec = 5;
        TimeoutStopSec = 30;

        RuntimeDirectory = "haos-vm";

        ExecStart = lib.getExe pkgs.cloud-hypervisor + '' \
  --cpus boot=2 \
  --memory size=4096M \
  --firmware ${pkgs.OVMF.fd}/FV/OVMF_CODE.fd \
  --disk path=/persist/microvms/haos/haos_ova-17.3.qcow2 \
  --net tap=vm-haos,mac=${mac} \
  --serial tty \
  --api-socket /run/haos-vm/ch.sock \
  --kernel /dev/null
'';

        ExecStop = ''
          if [ -S /run/haos-vm/ch.sock ]; then
          /run/current-system/sw/bin/ch-remote \
          --api-socket /run/haos-vm/ch.sock shutdown || true
          sleep 10
          fi
        '';

        KillMode = "process";
      };
    };
  };
}
