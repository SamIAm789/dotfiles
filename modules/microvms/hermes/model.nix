{
  flake.modules.nixos.hermes-agent = {

    services.hermes-agent.settings.model = {
      provider = "openai-codex";
      default = "gpt-6-sol";
    };
  };
}
