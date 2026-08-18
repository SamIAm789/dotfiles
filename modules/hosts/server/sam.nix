{
  flake.modules.nixos.server =
  {
    lib,
    ...
  }:
  {
    users.users.sam = {
      subUidRanges = [
        {
          startUid = 100000;
          count = 65536;
        }
      ];

      subGidRanges = [
        {
          startGid = 100000;
          count = 65536;
        }
      ];

      autoSubUidGidRange = lib.mkForce false;
    };
  };
}
