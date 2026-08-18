{
  flake.modules.nixos.server = {
    users.users.sam = {
      subUidRanges = [{ start = 100000; count = 65536; }];
      subGidRanges = [{ start = 100000; count = 65536; }];
    };
  };
}
