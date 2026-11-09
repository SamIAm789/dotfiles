{
  self,
  config,
  lib,
  ...
}:
let
  # Build checks for deployed NixOS hosts only.
  deploymentChecks = lib.mapAttrs'
    (name: _: {
      name = "deploy-${name}";
      value = self.nixosConfigurations.${name}.config.system.build.toplevel;
    })
    config.flake.deployNodes;

  # Add other checks here in the future.
  otherChecks = {
    # formatting = ...;
    # lint = ...;
    # tests = ...;
  };
in
{
  flake.checks.x86_64-linux =
    deploymentChecks // otherChecks;
}