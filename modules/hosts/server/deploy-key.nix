{
  inputs,
  ...
}:
{
  flake.module.nixos.server =
  let
    deployKeySopsFile = "${inputs.secrets}/secrets/secrets.yaml";
    deployKeyPath = "/etc/ssh/keys/config-deploy";
  in
  {

    sops.secrets."server-config-deploy" = {
      sopsFile = deployKeySopsFile;
      key = "server-config-deploy";
      owner = "root";
      group = "root";
      mode = "0600";
      path = deployKeyPath;
    };

    systemd.tmpfiles.rules = [
      "d /etc/ssh/keys 0700 root root -"
    ];

    programs.ssh.knownHosts.github = {
      hostNames = [ "github.com" ];
      publicKey = "github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMjv8L5XpTuJJhbpZisF/zLDA0zPMSvHdkr4UvCOqU";
    };

    environment.variables.GIT_SSH_COMMAND =
      "ssh -i ${deployKeyPath} -o IdentitiesOnly=yes";
  };
}
