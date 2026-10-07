{
  inputs,
  ...
}:
{
  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "google";

  flake.modules.nixos.google =
  {
    lib,
    ...
  }:
  {

    imports = with inputs.self.modules.nixos; [
      base
      crowdsec
      firewall-vps
      openssh-vps
    ];

    boot.loader = {
      systemd-boot.enable = lib.mkForce false;
      efi = {
        canTouchEfiVariables = lib.mkForce false;
        efiSysMountPoint = lib.mkForce "/boot/efi";
      };
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        efiInstallAsRemovable = true;
      };
    };

    boot.tmp.cleanOnBoot = true;

    zramSwap = {
      enable = true;
      algorithm = "zstd";
      memoryPercent = 50;
    };


    system.stateVersion = "26.05";

  };
}