{
  programs.ssh.knownHosts.backup = {
    hostNames = [
      "100.100.0.20"
      "backup"
    ];

    publicKey = "ssh-ed25519 AAAA...";
  };
}

ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBjeNyYqVL8gWcpQ+o7uMESxgEMBA6c9ewllL+jzbMlE backup