{
  inputs,
  ...
}:
{
  flake.modules.nixos.nebula =
  { config, lib, ... }:
  {
    imports = [
      inputs.dotfiles.modules.nixos.nebula
    ];

    services.nebula.networks.pertaka = {
      ca   = lib.mkForce "/var/lib/nebula/ca.crt";
      cert = lib.mkForce "/var/lib/nebula/host.crt";
      key  = lib.mkForce "/var/lib/nebula/host.key";
    };

    microvm.shares = [
      {
        proto = "virtiofs";
        tag = "nebula-secrets";
        source = "/persist/secrets/nebula/${config.networking.hostName}";
        mountPoint = "/var/lib/nebula";
        readOnly = true;
      }
    ];

    systemd.tmpfiles.rules = [
      "d /var/lib/nebula 0750 nebula-pertaka nebula-pertaka -"
    ];

    # Better ownership fix
    systemd.services.nebula-ownership-fix = {
      description = "Fix ownership of Nebula secrets for nebula-pertaka user";
      after = [ "var-lib-nebula.mount" ];
      requires = [ "var-lib-nebula.mount" ];
      before = [ "nebula@pertaka.service" ];
      wantedBy = [ "nebula@pertaka.service" ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        User = "root";
      };

      script = ''
        echo "Fixing ownership and permissions for Nebula secrets..."

        chown nebula-pertaka:nebula-pertaka /var/lib/nebula
        chmod 750 /var/lib/nebula

        chown nebula-pertaka:nebula-pertaka /var/lib/nebula/*.crt /var/lib/nebula/*.key 2>/dev/null || true
        chmod 444 /var/lib/nebula/*.crt
        chmod 400 /var/lib/nebula/*.key

        echo "Final permissions:"
        ls -la /var/lib/nebula
      '';
    };
  };
}
