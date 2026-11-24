{
  inputs,
  ...
}:
{
  flake.modules.homeManager.laptop = {
    imports = with inputs.self.modules.homeManager; [
      wluma
    ];
  };
}
