{
  lib,
  config,
  ...
}:
{
  options.flake.deployNodes = lib.mkOption {
    type = lib.types.attrsOf lib.types.attrs;
    default = {};
    description = "Per-host deploy-rs node definitions.";
  };

  config.flake.deploy = {
    nodes = config.flake.deployNodes;
  };
}
