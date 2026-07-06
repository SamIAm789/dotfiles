{
  flake.modules.nixos.preservation = {

    preservation = {
      enable = true;

      preserveAt."/persist" = {
        directories = [
          "/var/log"
          {
            directory = "/var/lib/nixos";
            inInitrd = true;
          }

          # sops-nix host AGE keys
          "/var/lib/sops-nix"

          "secrets/nebula"

        ];

        files = [
          { file = "/etc/machine-id"; }
          { file = "/etc/ssh/ssh_host_ed25519_key"; how = "symlink"; configureParent = true; }
          { file = "/var/lib/systemd/random-seed"; }
        ];


        users.sam = {
          directories = [
            ".ssh"
            ".config/systemd/user"
            ".config/containers"
            ".local/share/containers"
          ];
          files = [
            "/home/sam/.config/sops/age/keys.txt"
          ];
        };
      };
    };
    systemd.services.systemd-machine-id-commit.enable = false;
  };
}
