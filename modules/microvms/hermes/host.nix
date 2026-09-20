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
    sops.secrets."hermes-ssh-key" = {
      sopsFile = "${self}/secrets/hermes.yaml";
    };

    systemd.tmpfiles.rules = [
      "d /run/hermes-identity 0700 root root -"
    ];

    systemd.services.hermes-ssh-key = {
      wantedBy = [ "multi-user.target" ];
      after = [ "sops-install-secrets.service" ];
      requires = [ "sops-install-secrets.service" ];

      serviceConfig.Type = "oneshot";

      script = ''
        install -d -m 0700 /run/hermes-identity
        install -m 0400 \
          /run/secrets/hermes-ssh-key \
          /run/hermes-identity/hermes-ssh-key
      '';
    };
  };
}
