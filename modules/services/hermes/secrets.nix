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
      sopsFile = {self}/secrets/hermes.yaml;
      format = "yaml";
    };

    sops.templates."hermes.env" = {
      path = "/run/hermes-secrets/hermes.env";

      content = config.sops.placeholder."hermes-env";

      mode = "0400";
    };
  }:
}