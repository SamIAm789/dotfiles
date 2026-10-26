{
  flake.modules.nixos.oracle =
  {
    lib,
    ...
  }:
  {

     boot.loader = {
       systemd-boot.enable = lib.mkForce false;

     grub = {
       enable = true;
       efiSupport = true;
       device = "nodev";
       efiInstallAsRemovable = true;   # important on Oracle Cloud
       configurationLimit = 10;        # now safe
     };

     efi = {
       canTouchEfiVariables = lib.mkForce false;
       efiSysMountPoint = "/boot/efi";
     };
   };
 };
}