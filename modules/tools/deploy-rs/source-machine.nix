{
  self,
  ...
}:
{
  flake.modules.nixos.deploy-rs-source =
  {
    config,
    pkgs,
    ...
  }:
  {
    sops.secrets."deploy" = {
      sopsFile = "${self}/secrets/ssh.yaml";
      owner = "deploy-rs";
      group = "deploy-rs";
      mode = "0400";
    };

    users.users.deploy-rs = {
      home = "/var/lib/deploy-rs";
      createHome = true;
      shell = pkgs.bash;
    };

    programs.ssh.extraConfig = ''
      Match User deploy-rs
        IdentityFile ${config.sops.secrets.deploy.path}
        IdentitiesOnly yes
    '';

    systemd.tmpfiles.rules = [
      "d /var/lib/deploy-rs 0750 deploy-rs deploy-rs -"
      "d /var/lib/deploy-rs/.cache 0750 deploy-rs deploy-rs -"
    ];
  };
}
