{
  inputs,
  ...
}:
{
  flake.module.nixos.server =
  let
    deployKeySopsFile = "${inputs.secrets}/secrets/secrets.yaml";
  in
  {

    sops.secrets."server-config-deploy" = {
      sopsFile = deployKeySopsFile;
      key = "server-config-deploy";
      owner = "root";
      group = "root";
      mode = "0600";
      path = "/etc/ssh/keys/config-deploy";
    };

    sops.secrets."github-personal" = {
      sopsFile = deployKeySopsFile;
      key = "server-github-personal";
      owner = "root";
      group = "root";
      mode = "0600";
      path = "/etc/ssh/keys/github-personal";
    };

    systemd.tmpfiles.rules = [
      "d /etc/ssh/keys 0700 root root -"
    ];

    programs.ssh.knownHosts.github = {
      hostNames = [ "github.com" ];
      publicKey = "github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMjv8L5XpTuJJhbpZisF/zLDA0zPMSvHdkr4UvCOqU";
    };

    programs.ssh.extraConfig = ''
      Host github-secrets
        HostName github.com
        User git
        IdentityFile /etc/ssh/keys/github-secrets
        IdentitiesOnly yes

      Host github-personal
        HostName github.com
        User git
        IdentityFile /etc/ssh/keys/github-personal
        IdentitiesOnly yes
    '';
  };
}
