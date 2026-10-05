{
  inputs,
  ...
}:
{
  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "google";

  flake.modules.nixos.google = {

    imports = with inputs.self.modules.nixos; [
      base
      crowdsec
    ];

    boot.loader.systemd-boot.enable = lib.mkForce false;

    boot.loader.grub = {
      enable = true;
    # Most nixos-infect GCE instances are legacy BIOS
      device = "/dev/sda";          # change if your disk is different (check with lsblk)
    # If your instance is actually UEFI, u. se these instead:
    # device = "nodev";
    # efiSupport = true;
    # efiInstallAsRemovable = true;
  };

  # Optional: silence the EFI variable setting from base
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;


    system.stateVersion = "26.05";

  };
}