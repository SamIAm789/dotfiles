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
      owner = "deploy";
      group = "deploy";
      mode = "0400";
    };

    users.users.deploy = {
      home = "/var/lib/deploy";
      createHome = true;
      shell = pkgs.bash;
    };

    programs.ssh.extraConfig = ''
      Match User deploy
        IdentityFile ${config.sops.secrets.deploy.path}
        IdentitiesOnly yes
    '';

    environment.variables = {
      XDG_CACHE_HOME = "/var/lib/deploy/.cache";
    };

    systemd.tmpfiles.rules = [
      "d /var/lib/deploy 0750 deploy deploy -"
      "d /var/lib/deploy/.cache 0750 deploy deploy -"
    ];
  };
}
