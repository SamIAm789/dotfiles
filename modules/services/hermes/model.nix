{
  flake.modules.nixos.hermes = {

    services.hermes-agent.settings.model = {
      provider = "openrouter";
      default = "openrouter/free";
    };
  };
}
