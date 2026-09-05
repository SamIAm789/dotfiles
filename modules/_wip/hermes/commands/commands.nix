{
  flake.modules.nixos.hermes-commands = 
  {
    pkgs,
    ...
  }:
  {
    environment.systemPackages = [

      (pkgs.writeShellApplication {
        name = "hermes-network-status";

        runtimeInputs = [
          pkgs.iproute2
          pkgs.systemd
        ];

        text = ''
          echo "=== ADDRESSES ==="
          ip -br addr

          echo
          echo "=== ROUTES ==="
          ip route

          echo
          echo "=== LINKS ==="
          networkctl list

          echo
          echo "=== NETWORK STATUS ==="
          networkctl status --no-pager
        '';
      })

    (pkgs.writeShellApplication {
      name = "hermes-system-status";

      runtimeInputs = [
        pkgs.systemd
        pkgs.procps
        pkgs.util-linux
      ];

      text = ''
        echo "=== FAILED SERVICES ==="
        systemctl --failed --no-pager || true

        echo
        echo "=== MEMORY ==="
        free -h

        echo
        echo "=== UPTIME ==="
        uptime

        echo
        echo "=== BLOCK DEVICES ==="
        lsblk
      '';
    })

    (pkgs.writeShellApplication {
      name = "hermes-vm-status";

      runtimeInputs = [
        pkgs.systemd
      ];

      text = ''
        echo "=== MICROVM SERVICES ==="
        systemctl list-units \
          'microvm@*.service' \
          --all \
          --no-pager

        echo
        echo "=== MICROVM TARGET ==="
        systemctl status microvms.target \
          --no-pager || true
      '';
    })

    (pkgs.writeShellApplication {
      name = "hermes-zfs-status";

      runtimeInputs = [
        pkgs.zfs
      ];

      text = ''
        echo "=== ZPOOL STATUS ==="
        zpool status

        echo
        echo "=== ZFS DATASETS ==="
        zfs list
      '';
    })

    (pkgs.writeShellApplication {
      name = "hermes-container-status";

      runtimeInputs = [
        pkgs.podman
      ];

      text = ''
        podman ps --all
      '';
    })
  ];

  security.sudo.extraRules = [
    {
      users = [ "hermes" ];

      commands = [
        {
          command = "/run/current-system/sw/bin/hermes-network-status";
          options = [ "NOPASSWD" ];
        }

        {
          command = "/run/current-system/sw/bin/hermes-system-status";
          options = [ "NOPASSWD" ];
        }

        {
          command = "/run/current-system/sw/bin/hermes-vm-status";
          options = [ "NOPASSWD" ];
        }

        {
          command = "/run/current-system/sw/bin/hermes-zfs-status";
          options = [ "NOPASSWD" ];
        }

        {
          command = "/run/current-system/sw/bin/hermes-container-status";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
};
}