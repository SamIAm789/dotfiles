{
  flake.modules.nixos.server = {

    services.nfs.server.exports = ''
        /stuff/haos 10.25.0.0/24(rw,async,no_subtree_check,all_squash,anonuid=1003,anongid=1000)
      '';
  };
}
