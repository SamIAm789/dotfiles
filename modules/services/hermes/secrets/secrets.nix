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

    microvm.shares = [
      {
        proto = "virtiofs";
        tag = "hermes-secrets";
        source = "/run/hermes-secrets";
        mountPoint = "/run/hermes-secrets";
        readOnly = true;
        socket = "hermes-secrets.sock";
      }
    ];

    services.hermes-agent.environmentFiles = [
      "/run/hermes-secrets/hermes.env"
    ];
  };
}