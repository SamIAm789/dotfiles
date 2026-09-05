{
  flake.modules.nixos.hermes-user = {

    users.groups.hermes = {};

    users.users.hermes = {
      isSystemUser = true;
      group = "hermes";
      home = "/var/lib/hermes";
      createHome = true;

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAA... hermes@hermes"
    ];
  };
}