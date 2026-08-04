{
  flake.modules.nixos.framework = {
    environment.systemPackages = with pkgs; [
      opencloud-desktop
    ];
  };
}
