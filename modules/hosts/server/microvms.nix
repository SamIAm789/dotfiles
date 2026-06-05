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
    ];

    microvm.autostart = [
      "immich"
    ];
  };
}
