{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations =
    inputs.self.lib.mkMicroVM "x86_64-linux" "hermes";

  flake.modules.nixos.hermes = {
    imports = [
      self.modules.nixos.hermes-agent
    ];

    microvm = {
      hypervisor = "cloud-hypervisor";
      vcpu = 2;
      mem = 4096;
      vsock = {
        cid = 102;
        ssh.enable = true;
      };
      volumes = [
        {
          image = "/persist/microvms/hermes/root/root.img";
          mountPoint = "/";
          size = 16384;
          fsType = "ext4";
          autoCreate = true;
        }
      ];
      shares = [
        {
          source = "/persist/microvms/hermes/data";
          mountPoint = "/var/lib/hermes";
          tag = "hermes-data";
          proto = "virtiofs";
          socket= "hermes-data.sock";
        }
      ];
    };

    systemd.services.hermes-agent = {
      requires = [ "run-hermes\\x2dsecrets.mount" ];
      after = [ "run-hermes\\x2dsecrets.mount" ];
    };

    system.stateVersion = "26.05";
  };
}
