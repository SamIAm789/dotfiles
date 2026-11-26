{
  inputs,
  ...
}:
{

  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "macbook";

  flake.modules.nixos.macbook =
  {
    pkgs,
    ...
  }:
  {
    imports = with inputs.self.modules.nixos; [
      macbook-hardware
      laptop
      sam
    ];

    environment.systemPackages = with pkgs; [

    ];

    zramSwap.enable = true;
    zramSwap.algorithm = "zstd";

    system.stateVersion = "26.05";
  };
}
