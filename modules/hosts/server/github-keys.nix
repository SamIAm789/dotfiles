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

    # Ensure key directory exists
    systemd.tmpfiles.rules = [
      "d /etc/ssh/keys 0700 root root -"
    ];

    # --- DEPLOY KEY (secrets repo) ---
    sops.secrets."github-secrets" = {
      sopsFile = deployKeySopsFile;
      key = "server-config-deploy";
      owner = "root";
      group = "root";
      mode = "0600";
      path = "/etc/ssh/keys/github-secrets";
    };

    # --- PERSONAL GITHUB KEY ---
    sops.secrets."github-personal" = {
      sopsFile = deployKeySopsFile;
      key = "server-github-personal";
      owner = "root";
      group = "root";
      mode = "0600";
      path = "/etc/ssh/keys/github-personal";
    };

    # --- SSH CONFIG ---
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

    # Keep known hosts (good)
    programs.ssh.knownHosts.github = {
      hostNames = [ "github.com" ];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMjv8L5XpTuJJhbpZisF/zLDA0zPMSvHdkr4UvCOqU";
    };
  };
}
