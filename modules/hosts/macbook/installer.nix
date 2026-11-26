
{
  inputs,
  ...
}:
{
  flake.nixosConfigurations =
    inputs.self.lib.mkNixos "x86_64-linux" "macbook-installer";

  flake.modules.nixos.macbook-installer =
    {
      config,
      lib,
      modulesPath,
      pkgs,
      ...
    }:
    {
      imports = [
        (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
        (modulesPath + "/hardware/network/broadcom-43xx.nix")
      ];

      # Networking
      networking.networkmanager.enable = true;

      # SSH access
      services.openssh = {
        enable = true;
        openFirewall = true;

        settings = {
          PermitRootLogin = "prohibit-password";
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
        };
      };

      # Start SSH automatically
      systemd.services.sshd.wantedBy =
        lib.mkForce [ "multi-user.target" ];

      # Reuse the keys from your existing module for root access
      users.users.root = {
        hashedPassword = "$6$lb7BNjS.wIx4CFNs$5nXGTB8EMhbkbEKnDvrzikKHAy8pw92bQLrCHn98RlIjCidxH0Pwm1IlZ.XG9U69jfgHM.kpSpj.4wUTfl13Y/";
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINHptkyokSn8XreYaJQUyy1UPF8qiAq2cjCat3zPMO5Z user" #framework
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICxyLkFyzrqtcxLIK+H814/cd+OsvGva3IpHK/Iuey1F connectbot" #connectbot
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOS0RjZECCnmebiu1lw0LY9KaTthlUesI8AeqvtXg5fR" #server
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDERLAU69/5R61n5Oiv/VTc8RCKfuj/wbc3XJIJZXZ2D sam@backup" #backup
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOS0RjZECCnmebiu1lw0LY9KaTthlUesI8AeqvtXg5fR sam@server"
        ];
      };

      # Installation tools
      environment.systemPackages = with pkgs; [
        git
        fish
        micro
        curl
        wget
        tmux
        pciutils
        usbutils
      ];

      # Enable flakes
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
}
