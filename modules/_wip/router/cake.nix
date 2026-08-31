{
  flake.modules.nixos.router =
  {
    config,
    ...
  }:
  let
  # Upload / download in kbit/s (leave a little headroom)
  # Example: 100/20 Mbps → 95000 / 19000
    download  = 95000;
    upload    = 19000;

    cfg = config.router;
  in
  {
  # Enable CAKE on the WAN interface
    networking.interfaces.${cfg.wanIF}.cake = {
      enable = true;

      # Bandwidth limits (kbit/s)
      bandwidth = {
        download = download;
        upload   = upload;
      };

      # Good defaults for most home connections
      # (docsis / ethernet / pppoe-ptm / etc. – change if needed)
      overhead = 18; # typical for DOCSIS / Ethernet
      # mpu = 64;  # optional
      # atm = true;   # only if you still have ATM (rare)

      # Flow isolation + fairness
      flowmode = "triple-isolate"; # or "src-host", "dst-host", "flows"
      nat = true;  # important when the router does NAT

      # AQM / latency
      ack-filter = "aggressive";   # or "filter" / "none"
      # wash = true;   # clear DSCP if you want
    };

    # Make sure the sch_cake module is available
    boot.kernelModules = [ "sch_cake" ];
  };
}
