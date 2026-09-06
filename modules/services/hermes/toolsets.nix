{
  flake.modules.nixos.hermes = {
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
