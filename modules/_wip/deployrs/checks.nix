{
  self,
  inputs,
  lib,
  ...
}:
let
  system = "x86_64-linux";

  hostChecks = builtins.mapAttrs
    (_: cfg: cfg.config.system.build.toplevel)
    self.nixosConfigurations;

  deployChecks = inputs.deploy-rs.lib.${system}.deployChecks self.deploy;
in
{
  flake.checks.${system} = hostChecks // deployChecks;
}

# replace current checks.nix in tools with this to also add deploy checks
