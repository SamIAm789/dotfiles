{
  flake.modules.nixos.known-hosts =
  {
    config,
    ...
  }:
  {

    programs.ssh.knownHosts.oracle = {
      hostNames = [
        config.constants.nebula.oracle
        "oracle"
      ];

      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA1tWiSfWVoYyKP4sFz+csMQUuN542pkE0UaTP8/FMga oracle";
    };
  };
}