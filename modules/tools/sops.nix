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
  };

  flake.modules.nixos.sops = {

    imports = [
      inputs.sops-nix.nixosModules.sops
    ];

    sops = {

      useSystemdActivation = true;

      age = {
        sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
        keyFile = "/var/lib/sops-nix/key.txt";
        generateKey = true;
      };

      defaultSopsFile = "./secrets/secrets.yaml";
      defaultSopsFormat = "yaml";
    };
  };
}
