{
  inputs,
  self,
  ...
}:
{

  flake-file.inputs = {
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    secrets = {
     # url = "git+ssh://git@github.com/SamIAm789/secrets";
      url = "git+ssh://git@github-secrets:SamIAm789/private-secrets-repo.git";
      flake = false;
    };
  };

  flake.modules.nixos.sops = {

    imports = [
      inputs.sops-nix.nixosModules.sops
    ];

    sops = {

      age = {
        sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
        keyFile = "/var/lib/sops-nix/key.txt";
        generateKey = true;
      };

      defaultSopsFile = inputs.secrets + "/secrets/secrets.yaml";
      defaultSopsFormat = "yaml";
    };
  };
}
