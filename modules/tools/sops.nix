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
      };

      defaultSopsFile = "${self}/secrets/secrets.yaml";
      defaultSopsFormat = "yaml";
    };
  };
}
