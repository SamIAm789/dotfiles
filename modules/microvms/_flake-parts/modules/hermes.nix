{
  inputs,
  ...
}:
{
  flake.nixosConfigurations =
    inputs.self.lib.mkMicroVM "x86_64-linux" "hermes";

  flake.modules.nixos.hermes =
    { config, ... }:
    {
      imports = [
        inputs.hermes-agent.nixosModules.default
      ];

      microvm = {
        hypervisor = "cloud-hypervisor";

        vcpu = 2;
        mem = 4096;

        vsock.cid = 102;

        volumes = [
          {
            image = "/persist/microvms/hermes/root.img";
            mountPoint = "/";
            size = 16384;
            fsType = "ext4";
            autoCreate = true;
          }
        ];
      };

      services.hermes-agent = {
        enable = true;
        addToSystemPackages = true;

        settings = {

          model = {
            provider = "openrouter";
            default = "nvidia/nemotron-3-ultra-550b-a55b:free";
          };

          fallback_providers = [
            {
              provider = "openrouter";
              model = "qwen/qwen3.5-flash-02-23";
            }
          ];
          toolsets = [
            "terminal"
            "file"
            "homeassistant"
            "skills"
            "memory"
            "todo"
            "web"
          ];

          terminal.backend = "local";
        };
      };

      system.stateVersion = "26.05";
    };
}