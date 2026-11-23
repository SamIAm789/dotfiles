
{
  flake.modules.nixos.hermes-agent = {
    systemd.network.networks."20-lan".routes = [
      {
        Destination = "100.100.0.0/22";
        Gateway = "10.25.0.24";
      }
    ];
  };
}
