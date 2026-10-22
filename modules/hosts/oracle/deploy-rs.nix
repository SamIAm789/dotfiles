
{
  inputs,
  ...
}:
{
  flake.deploy.nodes =
    inputs.nixpkgs.lib.recursiveUpdate
      (inputs.self.lib.mkDeployNode "x86_64-linux" "oracle")
      {
        oracle = {
          hostname = "161.33.231.180";
        };
      };
}
