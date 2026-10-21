{
  inputs,
  ...
}:
{
  flake.deploy.nodes = (inputs.self.lib.mkDeployNode "x86_64-linux" "oracle") // {
    oracle.hostname = "161.33.231.180";
  };
}
