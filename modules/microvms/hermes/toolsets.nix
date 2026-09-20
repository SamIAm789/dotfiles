{
  flake.modules.nixos.hermes-agent = {
    services.hermes-agent.settings.toolsets = [
      "web"
      "terminal"
      "file"
      "code_execution"
      "todo"
      "memory"
      "skills"
      "clarify"
      "session_search"
    ];
  };
}
