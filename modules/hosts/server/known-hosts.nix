{
  flake.modules.nixos.known-hosts =
  {
    config,
    ...
  }:
  {

    programs.ssh.knownHosts.server = {
      hostNames = [
        config.constants.nebula.server
        "server"
      ];

      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICWnplqrouBGZUoEmMmPJ6R0izntujC59P2J/UMb/dWB root@server";
    };
  };
}