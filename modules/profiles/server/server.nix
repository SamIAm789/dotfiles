{
  inputs,
  ...
}:
{
  flake.modules.nixos.server-profile = {
    imports = with inputs.self.modules.nixos; [
      autoupdate
      base
      github-keys
      microvm-host
      network
      ntfy
      openssh
      preservation
      quadlet
      sanoid
      zfs
    ];
  };
}
