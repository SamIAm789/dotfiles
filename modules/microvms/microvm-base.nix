{
  flake.modules.nixos.base =
  {
    config,
    ...
  }:
  let
    hash = builtins.hashString "sha256" config.networking.hostName;

    mac =
      "02:"
      + builtins.substring 0 2 hash + ":"
      + builtins.substring 2 2 hash + ":"
      + builtins.substring 4 2 hash + ":"
      + builtins.substring 6 2 hash + ":"
      + builtins.substring 8 2 hash;
  in
  {
    microvm = {
      shares = [{
        proto = "virtiofs";
        tag = "ro-store";
        source = "/nix/store";
        mountPoint = "/nix/.ro-store";
      }];

      interfaces = [{
        type = "tap";
        id = "vm-${config.networking.hostName}";
        mac = mac;
      }];
    };

    systemd.network.enable = true;

    systemd.network.networks."20-lan" = {
      matchConfig.Type = "ether";
      networkConfig.DHCP = "yes";
    };

    users.users.sam = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      initialPassword = "test";
    };

    services.openssh.enable = true;
  };
}
