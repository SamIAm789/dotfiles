{
  flake.modules.nixos.haos =
    {
      lib,
      pkgs,
      ...
    }:

    let
      mkMac = vmName:
        let
          hash = builtins.hashString "sha256" vmName;
        in
          "02:"
          + builtins.substring 0 2 hash + ":"
          + builtins.substring 2 2 hash + ":"
          + builtins.substring 4 2 hash + ":"
          + builtins.substring 6 2 hash + ":"
          + builtins.substring 8 2 hash;
      vmName = "vm-haos";
      mac = mkMac "haos";
    in
     {
      environment.systemPackages = [ pkgs.qemu ];
      systemd.services.haos-vm = {
        description = "Home Assistant OS VM (QEMU/KVM)";
        wantedBy = [ "multi-user.target" ];
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        serviceConfig = {
          Type = "simple";
          Restart = "on-failure";
          RestartSec = 5;
          KillMode = "process";
          TimeoutStopSec = 30;

          ExecStart = ''
            ${pkgs.qemu}/bin/qemu-system-x86_64 \
              -name haos \
              -machine q35,accel=kvm \
              -cpu host \
              -smp 2 \
              -m 4096 \
              -nographic \
              -serial mon:stdio \
              -drive file=/persist/microvms/haos/haos_ova-17.3.qcow2,format=qcow2,if=virtio \
              -netdev tap,id=net0,ifname=${vmName},script=no,downscript=no \
              -device virtio-net-pci,netdev=net0,mac=${mac}
          '';

          ExecStop = ''
            ${pkgs.qemu}/bin/qemu-img snapshot -a stop || true
          '';
        };
        environment.systemPackages = [ pkgs.qemu ];
      };
    };
}
