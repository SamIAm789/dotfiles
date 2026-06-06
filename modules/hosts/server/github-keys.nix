{ inputs, ... }:
{
  flake.modules.nixos.server =
  let
    deployKeySopsFile = "${inputs.secrets}/secrets/secrets.yaml";
  in
  {

    systemd.tmpfiles.rules = [
      "d /etc/ssh/keys 0700 root root -"
    ];

    # --- DEPLOY KEY (read-only repo access) ---
    sops.secrets.github-secrets = {
      sopsFile = deployKeySopsFile;
      key = "server-config-deploy";
      owner = "root";
      group = "root";
      mode = "0600";
      path = "/etc/ssh/keys/github-secrets";
    };

    # --- PERSONAL GITHUB KEY (used for git push) ---
    sops.secrets.github-personal = {
      sopsFile = deployKeySopsFile;
      key = "server-github-personal";
      owner = "root";
      group = "root";
      mode = "0600";
      path = "/etc/ssh/keys/github-personal";
    };

    # --- SSH CONFIG (IMPORTANT FIX HERE) ---
    programs.ssh.extraConfig = ''
      Host github.com
        HostName github.com
        User git
        IdentityFile /etc/ssh/keys/github-personal
        IdentitiesOnly yes

      Host github-deploy
        HostName github.com
        User git
        IdentityFile /etc/ssh/keys/github-secrets
        IdentitiesOnly yes
    '';

    # known hosts (fine as-is)
    programs.ssh.knownHosts.github = {
      hostNames = [ "github.com" ];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMjv8L5XpTuJJhbpZisF/zLDA0zPMSvHdkr4UvCOqU";
    };
  };
}
