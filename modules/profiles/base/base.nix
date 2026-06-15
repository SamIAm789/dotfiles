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
      imports = with inputs.self.modules.nixos; [
        boot
        firmware
        fish
        home-manager
        nebula
        nebula-secrets
        nix
        sam
        secrets-deploy-key
        ssh-agent
        ssh-auth-keys
        sops
        timezone
      ];

      environment.systemPackages = with pkgs; [
        fzf
        git
      ];
    };
}
