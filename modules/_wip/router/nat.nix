{
  flake.modules.nixos.router = {

    networking.nat = {
      enable = true; 
      externalInterface = ${wanIF};
      internalInterfaces = [ "${lanIF}" ];
    };
  };
}
      