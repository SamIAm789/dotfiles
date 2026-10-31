{
  flake.modules.nixos.framework = {

          services.nebula.networks.pertaka.settings = {
       tun.unsafe_routes = [
         {
            route = "10.25.0.0/24";
            via = "100.100.0.10";
         }
       ];
    };
  };
}
