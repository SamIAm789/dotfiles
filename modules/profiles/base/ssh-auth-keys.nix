{
  flake.modules.nixos.ssh-auth-keys =
    {

      users.users.sam.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINHptkyokSn8XreYaJQUyy1UPF8qiAq2cjCat3zPMO5Z user" #framework
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICxyLkFyzrqtcxLIK+H814/cd+OsvGva3IpHK/Iuey1F connectbot" #connectbot
        "AAAAC3NzaC1lZDI1NTE5AAAAIOS0RjZECCnmebiu1lw0LY9KaTthlUesI8AeqvtXg5fR" #server
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDERLAU69/5R61n5Oiv/VTc8RCKfuj/wbc3XJIJZXZ2D sam@backup" #backup
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOS0RjZECCnmebiu1lw0LY9KaTthlUesI8AeqvtXg5fR sam@server"
      ];
    };
}
