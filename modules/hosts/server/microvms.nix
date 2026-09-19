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
      inputs.self.modules.nixos.hermes-vm-host
    ];

    microvm.autostart = [
      "immich"
      "hermes"
    ];
  };
}
