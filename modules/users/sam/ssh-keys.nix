{
  inputs,
  ...
}:
{
  flake.modules.nixos.sam-ssh-keys =
  {
    config,
    ...
  }:
  {
    sops.secrets.github-personal-key = {
      owner = "sam";
      group = "users";
      mode = "0400";
    };

    programs.ssh.extraConfig = ''
      Match User sam Host github.com
        IdentityFile ${config.sops.secrets.github-personal-key.path}
        IdentitiesOnly yes
    '';
  };
}
