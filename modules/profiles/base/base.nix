{
  inputs,
  ...
}:
{

  flake.modules.nixos.base =
    {
      pkgs,
      ...
    }:
    {
      imports =
      (with inputs.self.modules.nixos; [
        boot
        deploy-rs
        firmware
        fish
        home-manager
        nebula
        nebula-secrets
        nix
        sam
        ssh-agent
        ssh-auth-keys
        sops
        timezone
        userborn
      ])
      ++ [
        inputs.self.modules.generic.constants
      ];

      environment.systemPackages = with pkgs; [
        fzf
        git
        jq
        ripgrep
      ];
    };
}
