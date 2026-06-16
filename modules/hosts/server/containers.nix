{
  inputs,
  self,
  ...
}:
{
  flake.modules.nixos.server = {
    imports = with inputs.self.modules.nixos; [
      norish-hm
    ];
  };
}
