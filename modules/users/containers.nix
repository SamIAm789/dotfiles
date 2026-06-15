{
  inputs,
  self,
  ...
}:

let
  username = "containers";
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
      ];

      home-manager.users."${username}" = {
        imports = [
          inputs.self.modules.homeManager."${username}"
        ];
      };

      users.users.${username} = {
        isSystemUser = true;
        linger = true;
        autoSubUidGidRange = true;
        group = "${username}";
        home = "/var/lib/${username}";
      };
      users.groups.${username} = {};
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
