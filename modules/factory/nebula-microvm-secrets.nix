{
  self,
  ...
}:
{
  flake.factory.nebulaSecrets =
    { vm, storageDir ? "/persist/secrets/nebula/${vm}" }:
    { config, lib, ... }:
    let
      sopsFile = "${self}/secrets/nebula.yaml";
    in
    {
      # SOPS secrets (decrypted to /run/secrets)
      sops.secrets."nebula.${vm}.ca" = {
        sopsFile = sopsFile;
        key = "nebula/ca";
        path = "/run/secrets/nebula/${vm}/ca.crt";
        mode = "0400";
      };

      sops.secrets."nebula.${vm}.crt" = {
        sopsFile = sopsFile;
        key = "nebula/${vm}/crt";
        path = "/run/secrets/nebula/${vm}/host.crt";
        mode = "0400";
      };

      sops.secrets."nebula.${vm}.key" = {
        sopsFile = sopsFile;
        key = "nebula/${vm}/key";
        path = "/run/secrets/nebula/${vm}/host.key";
        mode = "0400";
      };

      systemd.tmpfiles.rules = [
        "d ${storageDir} 0750 nebula-pertaka nebula-pertaka -"
      ];

      # Improved copy service - no dependency on missing sops-nix.service
      systemd.services."nebula-secrets-copy-${vm}" = {
        description = "Copy Nebula secrets for ${vm} to persistent storage";
        after = [ "multi-user.target" ];           # More reliable
        wants = [ "multi-user.target" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          User = "root";
        };

        script = ''
          echo "=== Nebula secrets copy for ${vm} ==="
          mkdir -p ${storageDir}

          SRC="/run/secrets/nebula/${vm}"
          if [ ! -f "$SRC/ca.crt" ] || [ ! -f "$SRC/host.crt" ] || [ ! -f "$SRC/host.key" ]; then
            echo "ERROR: Source secrets not found in $SRC"
            echo "Contents of /run/secrets/nebula/${vm}:"
            ls -la "$SRC" || echo "Directory does not exist"
            exit 1
          fi

          chown 945:945 ${storageDir}
          chmod 750 ${storageDir}

          cp -f "$SRC/ca.crt"     ${storageDir}/ca.crt
          cp -f "$SRC/host.crt"   ${storageDir}/host.crt
          cp -f "$SRC/host.key"   ${storageDir}/host.key

          chmod 444 ${storageDir}/*.crt
          chmod 400 ${storageDir}/*.key
          chown 945:945 ${storageDir}/*

          echo "✅ Secrets copied successfully to ${storageDir}"
          ls -la ${storageDir}
        '';
      };
    };
}
