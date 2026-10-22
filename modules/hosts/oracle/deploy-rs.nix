
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

      # sudo -u deploy-rs env \
      #  HOME=/var/lib/deploy-rs \
      #  XDG_CACHE_HOME=/var/lib/deploy-rs/.cache \
      #  PATH=/run/current-system/sw/bin:/run/wrappers/bin \
      #  nix run nixpkgs#deploy-rs -- github:SamIAm789/dotfiles#oracle
}
