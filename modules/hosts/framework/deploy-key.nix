{
  inputs,
  ...
}:
{
  flake.modules.nixos.deploy-key-framework =
  let

    keyPath = "/etc/ssh/keys/framework-dotfiles-deploy";
  in
  {

    systemd.tmpfiles.rules = [
      "d /etc/ssh/keys 0700 root root -"
    ];
    sops.secrets."deploy-key" = {
      sopsFile = "${inputs.secrets}/secrets/secrets.yaml";
      owner = "root";
      group = "root";
      mode = "0600";
      path = keyPath;
    };
    environment.etc."ssh/ssh_config.d/deploy-key.conf".text = ''
      Host github.com
        IdentityFile ${keyPath}
        IdentitiesOnly yes
    '';
    programs.ssh.knownHosts.github = {
      hostNames = [ "github.com" ];
      publicKey = "github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMjv8L5XpTuJJhbpZisF/zLDA0zPMSvHdkr4UvCOqU";
    };
  };
}
