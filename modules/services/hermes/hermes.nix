{
  inputs,
  self,
  ...
}:
{
  flake-file.inputs.hermes-agent.url = "github:NousResearch/hermes-agent";

  flake.modules.nixos.hermes-agent =
  {
    config,
    ...
  }:
  {

    imports = [
      inputs.hermes-agent.nixosModules.default
      self.modules.nixos.sops
    ];

    sops.secrets."hermes-env" = {
      sopsFile = "${self}/secrets/hermes.yaml";
      format = "yaml";
    };

    services.hermes-agent = {
      enable = true;
      environmentFiles = [ config.sops.secrets."hermes-env".path ];
      addToSystemPackages = true;
      extraDependencyGroups = [ "messaging" ];
    };
  };
}
