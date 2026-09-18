{
  inputs,
  self,
  ...
}:
{
  flake-file.inputs.hermes-agent.url = "github:NousResearch/hermes-agent";

  flake.modules.nixos.hermes-agent = {

    imports = [
      inputs.hermes-agent.nixosModules.default
    ];

    services.hermes-agent = {
      enable = true;
      addToSystemPackages = true;
      extraDependencyGroups = [ "messaging" ];
    };
  };
}
