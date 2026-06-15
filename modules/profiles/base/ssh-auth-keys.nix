{
  flake.modules.nixos.ssh-auth-keys =
    {

      users.users.sam.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINHptkyokSn8XreYaJQUyy1UPF8qiAq2cjCat3zPMO5Z user" #framework
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMHV+lxnSONakDVuDrD3qcKWLKj4JCu05VEe8EeyCDIB u0_a402@localhost" #termux
      ];
    };
}
