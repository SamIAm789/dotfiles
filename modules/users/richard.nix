{
  inputs,
  self,
  ...
}:

let
  username = "rich";
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
        hashedPasswordFile = config.sops.secrets.rich.path;
      };

      sops.secrets.rich = {
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
      home.stateVersion = "26.05";
    };
}
