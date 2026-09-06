{
  flake-file.inputs.hermes-agent.url = "github:NousResearch/hermes-agent";

  flake.modules.nixos.hermes = {

    imports = [ hermes-agent.nixosModules.default ];

    sops = {
      defaultSopsFile = ./secrets/hermes.yaml;
      secrets."hermes-env" = { format = "yaml"; };
     };

    services.hermes-agent.environmentFiles = [
      config.sops.secrets."hermes-env".path
    ];

    services.hermes-agent = {
      enable = true;
      environmentFiles = [ config.sops.secrets."hermes-env".path ];
      addToSystemPackages = true;
      extraDependencyGroups = [ "messaging" ];
    };
  }:
}
