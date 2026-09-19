{
  self,
  ...
}:
{
  flake.modules.nixos.hermes-vm-host =
  {
    config,
    ...
  }:
  {
    sops.secrets."hermes-env" = {
      sopsFile = "${self}/secrets/hermes.yaml";
      format = "yaml";
    };

    systemd.tmpfiles.rules = [
      "d /run/hermes-secrets 0750 root microvm -"
    ];

    sops.templates."hermes.env" = {
      path = "/run/hermes-secrets/hermes.env";
      content = config.sops.placeholder."hermes-env";
      mode = "0440";
      owner = "root";
      group = "microvm";
    };
  };
}
