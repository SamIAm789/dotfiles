{
  self,
  ...
}:
{
  flake.modules.nixos.deploy-rs-source =
  {
    config,
    ...
  }:
  {
    sops.secrets."deploy" = {
      sopsFile = "${self}/secrets/ssh.yaml";
      owner = "deploy";
      group = "deploy";
      mode = "0400";
    };

    environment.etc."ssh/ssh_config.d/60-deploy-key.conf".text = ''
      Match User deploy
        IdentityFile ${config.sops.secrets.deploy.path}
        IdentitiesOnly yes
    '';
  };
}
