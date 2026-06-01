{
  inputs,
  ...
}:
{
  flake.modules.nixos.server-profile = {
    imports = with inputs.self.modules.nixos; [
      autoupdate
      base
      microvm-host
      network
      ntfy
      openssh
      preservation
      sanoid
      zfs
    ];
  };
}
