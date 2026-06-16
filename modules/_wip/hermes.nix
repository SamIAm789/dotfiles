{
  flake-file.inputs.hermes-agent.url = "github:NousResearch/hermes-agent";

  flake.modules.nixos.hermes = {
    
    imports = [ hermes-agent.nixosModules.default ];

    sops = {
      defaultSopsFile = ./secrets/hermes.yaml;
      age.keyFile = "/home/user/.config/sops/age/keys.txt";
      secrets."hermes-env" = { format = "yaml"; };
     };

    services.hermes-agent.environmentFiles = [
      config.sops.secrets."hermes-env".path
    ];

    services.hermes-agent = {
      enable = true;
      settings.model.default = "anthropic/claude-sonnet-4";
      environmentFiles = [ config.sops.secrets."hermes-env".path ];
      addToSystemPackages = true;
      extraDependencyGroups = [ "messaging" ];
    };
  }:
}