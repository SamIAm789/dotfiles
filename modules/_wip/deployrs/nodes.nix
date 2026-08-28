{
  inputs,
  self,
  ...
}:
{
  flake.depoloy.nodes = with self.lib; lib.mkMerge [
     (mkDeployNode "x86_64-linux" "server")
     (mkDeployNode "x86_64-linux" "backup")
     (mkDeployNode "x86_64-linux" "thinkpad")
   ];
}
