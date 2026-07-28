{
  self,
  ...
}:
{
  flake.modules.nixos.nebula-secrets =
  {
    config,
    ...
  }:
  let
    host = config.networking.hostName;
    sopsFile = "${self}/secrets/nebula.yaml";
    nebulaUser = "nebula-pertaka";
    nebulaGroup = "nebula-pertaka";
  in
  {
    sops.secrets = {
      "nebula.ca" = {
        inherit sopsFile;
        key = "nebula/ca";
        owner = nebulaUser;
        group = nebulaGroup;
        mode = "0400";
        restartUnits = [ "nebula@pertaka.service" ];
      };

      "nebula.${host}.crt" = {
        inherit sopsFile;
        key = "nebula/${host}/crt";
        owner = nebulaUser;
        group = nebulaGroup;
        mode = "0400";
      };

      "nebula.${host}.key" = {
        inherit sopsFile;
        key = "nebula/${host}/key";
        owner = nebulaUser;
        group = nebulaGroup;
        mode = "0400";
      };
    };
    services.nebula.networks.pertaka = {
      ca = config.sops.secrets."nebula.ca".path;
      cert = config.sops.secrets."nebula.${host}.crt".path;
      key  = config.sops.secrets."nebula.${host}.key".path;
    };
  };
}
