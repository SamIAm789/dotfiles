{
  inputs,
  self,
  ...
}:

let
  username = "sam";
in
{
  flake.homeConfigurations = inputs.self.lib.mkHomeManager "x86_64-linux" "sam";

  flake.modules.nixos."${username}" =
    {
      config,
      lib,
      ...
    }:
    {
      imports = [
        inputs.home-manager.nixosModules.home-manager
        inputs.sops-nix.nixosModules.sops
        inputs.self.modules.nixos.sam-ssh-keys
      ];

      home-manager.users."${username}" = {
        imports = [
          inputs.self.modules.homeManager."${username}"
        ];
      };

      users.users.${username} = {
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "networkmanager"
        ];
        autoSubIdRange = true;
        hashedPasswordFile = config.sops.secrets.sam.path;
       # initialHashedPassword = lib.mkDefault "$y$j9T$isUS3neJEEFmJTYteyeHx1$RG2NFoIf.eBb0rELDl1aTCP0c4aC/33GpIKzFkCIKm2";
      };

      sops.secrets.sam = {
        owner = "root";
        group = "root";
        mode = "0400";
        neededForUsers = true;
      };
    };

  flake.modules.homeManager."${username}" =
    {
      pkgs,
      ...
    }:
    {
      imports = with inputs.self.modules.homeManager; [

      ];
      home.username = "${username}";
      home.packages = with pkgs; [

      ];
      home.stateVersion = "25.05";
    };
}
