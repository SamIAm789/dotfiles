# Fix: Accessing LAN devices with Nebula enabled

## Symptom

When a phone connects to a LAN device through Nebula, the request
reaches the device, but replies fail. OPNsense may log the reply as
**Default deny / state violation**.

## Cause

The LAN device sends replies for the Nebula subnet (`100.100.0.0/22`) to
its normal default gateway, OPNsense (`10.25.0.1`). The reply needs to
go back through the NixOS Nebula server instead (`10.25.0.24`).

## Temporary fix / test

Run on the affected LAN device:

``` sh
sudo ip route add 100.100.0.0/22 via 10.25.0.24
```

Test access from the phone while Nebula is enabled.

## Make it permanent on NixOS

Add this to the affected machine's NixOS configuration:

``` nix
networking.routes = [
  {
    address = "100.100.0.0";
    prefixLength = 22;
    via = "10.25.0.24";
  }
];
```

Rebuild the machine, then verify the route:

``` sh
ip route get 100.100.0.41
```

The result should show `via 10.25.0.24` (and the machine's LAN
interface/source address).

## Notes

-   `10.25.0.24` is the Nebula server's LAN address.
-   `100.100.0.0/22` is the Nebula network.
-   Apply the route to each LAN device that needs to reply directly to
    Nebula clients, such as Hermes (`10.25.0.33`) or the TWCManager Pi.
-   This is a return-route fix; it preserves the original Nebula client
    IP and avoids introducing NAT.
