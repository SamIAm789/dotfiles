{
  self,
  ...
}:
{
  flake.modules.nixos.hermes =
  {
    config,
    ...
  }:
  {

    sops.secrets."hermes-env" = {
      sopsFile = "${self}/secrets/hermes.yaml";
      neededForUsers = true;
    };

    services.hermes-agent.environmentFiles = [
      config.sops.secrets."hermes-env".path
    ];
  };
}
