{
  inputs,
  ...
}:
{
  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "oracle";

  flake.modules.nixos.oracle =
  {
    lib,
    ...
  }:
  {

    imports = with inputs.self.modules.nixos; [
      base
      crowdsec
      firewall-vps
      oracle-disko
      openssh-vps
      vps
    ];

    boot.loader = {
      efi = {
        canTouchEfiVariables = lib.mkForce false;
        efiSysMountPoint = lib.mkForce "/boot";
      };
    };

    boot.tmp.cleanOnBoot = true;

    zramSwap = {
      enable = true;
      algorithm = "zstd";
      memoryPercent = 150;
      priority = 100;
    };

    system.stateVersion = "26.05";
  };
}
