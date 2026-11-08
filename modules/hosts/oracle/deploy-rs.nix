{
  inputs,
  ...
}:
{
  flake.deployNodes.oracle =
    inputs.self.lib.mkDeployNode
      "x86_64-linux"
      "oracle"
      "100.100.0.3";

      # sudo -u deploy-rs env \
      #  HOME=/var/lib/deploy-rs \
      #  XDG_CACHE_HOME=/var/lib/deploy-rs/.cache \
      #  PATH=/run/current-system/sw/bin:/run/wrappers/bin \
      #  nix run nixpkgs#deploy-rs -- github:SamIAm789/dotfiles#backup
}
