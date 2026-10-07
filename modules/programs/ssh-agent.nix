{
  flake.modules.nixos.ssh-agent = {
    programs.ssh = {
      startAgent = true;
      extraConfig = ''
        Host backup
          User sam
          HostName 10.25.0.142

        Host backup-nebula
          User sam
          HostName 100.100.0.5

        Host github
          HostName github.com
          IdentityFile home/sam/.ssh/id_ed25519

        Host google
          HostName 35.209.173.73

        Host server
          User sam
          HostName 10.25.0.24

        Host server-nebula
          User sam
          HostName 100.100.0.4

        Host twcmanager
          User sam
          HostName 10.25.0.30

        Host *
          ForwardAgent yes
          AddKeysToAgent yes
      '';
    };
  };
}
