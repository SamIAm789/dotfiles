{
  inputs,
  ...
}:
{
  flake.deploy.nodes = inputs.self.lib.mkDeployNode "x86_64-linux" "google";
}
