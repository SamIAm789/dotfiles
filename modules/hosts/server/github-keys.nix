{
  self,
  ...
}:

{
  flake.modules.nixos.server = let
    deployKeySopsFile = "${self}/secrets/secrets.yaml";
  in {

    # sops-managed SSH key (user-owned, not system-owned)
    sops.secrets.github-personal = {
      sopsFile = deployKeySopsFile;
      key = "server-github-personal";

      path = "/home/sam/.ssh/github-personal";

      owner = "sam";
      group = "users";
      mode = "0600";
    };

    systemd.tmpfiles.rules = [
      "d /home/sam/.ssh 0700 sam users -"
    ];

    programs.ssh.extraConfig = ''
      Host github-personal
        HostName github.com
        User git
        IdentityFile /home/sam/.ssh/github-personal
        IdentitiesOnly yes
    '';
  };
}
