{
  inputs,
  ...
}:
{
  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "thinkpad";

  flake.modules.nixos.thnkpad = {

    imports = with inputs.self.modules.nixos; [
      sam
      rich
      base
      ntfy
      autoupdate
      openssh
    ];

    system.stateVersion = "26.05";

  };
}
