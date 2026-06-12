{
  inputs,
  ...
}:
let
  home-manager-config =
    { lib, ... }:
    {
      home-manager = {
        useUserPackages = true;
        useGlobalPkgs = true;
      };
    };
in
{
  flake-file.inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  imports = [ inputs.home-manager.flakeModules.home-manager ];

  flake.modules.nixos.home-manager = {
    imports = [
      inputs.home-manager.nixosModules.home-manager
      home-manager-config
    ];
  };

  flake.modules.darwin.home-manager = {
    imports = [
      inputs.home-manager.darwinModules.home-manager
      home-manager-config
    ];
  };
}
