{
  inputs,
  self,
  ...
}:
{
  flake.modules.nixos.server = {

    imports = [
      (self.factory.nebulaSecrets { vm = "immich"; })
      inputs.self.modules.nixos.haos-ch
inputs.self.modules.nixos.haos-share
    ];

    microvm.autostart = [
      "immich"
    ];
  };
}
