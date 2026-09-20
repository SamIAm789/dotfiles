{
  self,
  ...
}:
{
  flake.modules.nixos.hermes-vm-host =
  {
    config,
    pkgs,
    ...
  }:
  {
    sops.secrets."hermes-env" = {
      sopsFile = "${self}/secrets/hermes.yaml";
      format = "yaml";
      path = "/run/hermes-secrets/hermes.env";
      mode = "0440";
    };

    systemd.tmpfiles.rules = [
      "d /run/hermes-secrets 0750 root microvm -"
    ];
  };
}
