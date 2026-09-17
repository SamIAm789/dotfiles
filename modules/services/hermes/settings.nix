{
  flake.modules.nixos.hermes-agent = {
    services.hermes-agent.settings = {
      terminal = {
        backend = "local";
        timeout = 180;
      };
      memory = {
        memory_enabled = true;
        user_profile_enabled = true;
      };
    };
  };
}
