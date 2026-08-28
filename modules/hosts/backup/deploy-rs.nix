{
  self,
  ...
}:
{
  flake.deploy.nodes = self.lib.mkDeployNode "x86_64-linux" "backup";
}
