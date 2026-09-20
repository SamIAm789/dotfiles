{
  flake.modules.nixos.hermes-agent = {

    services.hermes-agent.settings.model = {
      provider = "openrouter";
      default = "openrouter/free";
    };
  };
}
