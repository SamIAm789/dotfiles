{
  inputs,
  ...
}:
{
  flake.modules.nixos.server-profile = {
    imports = with inputs.self.modules.nixos; [
      autoupdate
      base
      known-hosts
      microvm-host
      network
      ntfy
      openssh
      preservation
      prometheus-exporter
      quadlet
      sanoid
      zfs
    ];
  };
}
