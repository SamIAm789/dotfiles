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
        ssh-agent
        ssh-auth-keys
        sops
        timezone
        userborn
      ];

      environment.systemPackages = with pkgs; [
        fzf
        git
      ];
    };
}
