{
  flake.modules.nixos.known-hosts =
  {
    config,
    ...
  }:
  {

    programs.ssh.knownHosts.backup = {
      hostNames = [
        "config.constants.nebula.backup"
        "backup"
      ];

      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBjeNyYqVL8gWcpQ+o7uMESxgEMBA6c9ewllL+jzbMlE backup";
    };
  };
}

