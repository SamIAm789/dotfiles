{
  inputs,
  lib,
  self,
  ...
}:
let
  system = "x86_64-linux";
  activate = inputs.deploy-rs.lib.${system}.activate.nixos;

  # Shared defaults – tweak sshUser / hostname if needed
  mkNode =
    {
      name,
      hostname ? name, # override with IP / Tailscale / FQDN if desired
      remoteBuild ? false,
      sshUser ? "deploy",
      ...
    }:
    {
      inherit hostname;
      inherit remoteBuild;
      sshUser = sshUser;
      # sshOpts = [ "-p" "22" ];
      # fastConnection = true;  # enable if the link is reliable & fast

      profiles.system = {
        user = "root";
        path = activate self.nixosConfigurations.${name};
      };
    };
in
{
  flake.deploy.nodes = {
    # Local build (build on the machine you run `deploy` from)
    server = mkNode {
      name = "server";
      # hostname = "10.25.0.24";   # uncomment / change if needed
      remoteBuild = false;
    };

    backup = mkNode {
      name = "backup";
      remoteBuild = false;
    };

    # Remote build (build on the ThinkPad itself)
    thinkpad = mkNode {
      name = "thinkpad";
      remoteBuild = true;
    };
  };

  # Optional but useful: deploy-rs checks become part of `nix flake check`
  flake.checks = builtins.mapAttrs
    (_: deployLib: deployLib.deployChecks self.deploy)
    inputs.deploy-rs.lib;
}
