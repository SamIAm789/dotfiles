{
  flake-file.inputs.hermes-agent.url = "github:NousResearch/hermes-agent";

  flake.modules.nixos.hermes = {
    
    imports = [ hermes-agent.nixosModules.default ];

    config.sops.secrets."hermes-env" = { };

    services.hermes-agent = {
    enable = true;
    settings.model.default = "anthropic/claude-sonnet-4";
    environmentFiles = [ config.sops.secrets."hermes-env".path ];
    addToSystemPackages = true;
  };