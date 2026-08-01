{
  inputs,
  ...
}:
{
  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "thinkpad";

  flake.modules.nixos.thinkpad = {

    imports = with inputs.self.modules.nixos; [
      sam
      richardr
      base
      ntfy
      autoupdate
      openssh
    ];

    system.stateVersion = "26.05";

  };
}
