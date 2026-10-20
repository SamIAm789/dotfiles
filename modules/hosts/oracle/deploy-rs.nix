{
  inputs,
  ...
}:
{
  flake.deploy.nodes = inputs.self.lib.mkDeployNode "x86_64-linux" "oracle";

  flake.deploy.nodes.oracle.hostname = "161.33.231.180";
}
