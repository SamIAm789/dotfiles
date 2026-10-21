{
  self,
  ...
}:
{
  flake.checks.x86_64-linux =
    builtins.mapAttrs
      (_: cfg: cfg.config.system.build.toplevel)
      (builtins.removeAttrs self.nixosConfigurations [ "framework" ]);
}
