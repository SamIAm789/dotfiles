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
      inputs.hermes-agent.nixosModules.default
      self.modules.nixos.hermes-agent
    ];

    microvm = {
      hypervisor = "cloud-hypervisor";
      vcpu = 2;
      mem = 4096;
      vsock.cid = 102;
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
    system.stateVersion = "26.05";
  };
}
