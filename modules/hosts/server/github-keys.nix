{
  inputs,
  ...
}:

{
  flake.modules.nixos.server = let
    deployKeySopsFile = "${inputs.secrets}/secrets/secrets.yaml";
  in {

    systemd.tmpfiles.rules = [
      "d /etc/ssh/keys 0700 root root -"
    ];

    # --- DEPLOY KEY ---
    sops.secrets.github-secrets = {
      sopsFile = deployKeySopsFile;
      key = "server-config-deploy";
      mode = "0400";
      owner = "root";
      group = "root";
      path = "/etc/ssh/keys/github-secrets";
    };

    # --- PERSONAL KEY ---
    sops.secrets.github-personal = {
      sopsFile = deployKeySopsFile;
      key = "server-github-personal";

      path = "/etc/ssh/keys/github-personal";

      owner = "root";
      group = "root";
      mode = "0400";
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

    programs.ssh.knownHosts.github = {
      hostNames = [ "github.com" ];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMjv8L5XpTuJJhbpZisF/zLDA0zPMSvHdkr4UvCOqU";
    };
  };
}
