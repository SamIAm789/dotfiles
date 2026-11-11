{
  self,
  ...
}:
{
  flake.modules.nixos.immich-host = {

        imports = [
      (self.factory.nebulaSecrets { vm = "immich"; }) ];
  };
}