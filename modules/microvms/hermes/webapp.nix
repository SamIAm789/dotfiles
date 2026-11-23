{
  flake.modules.nixos.hermes-agent = {

    services.hermes-agent.settings = {
      
     webapp = {
        enabled = true;
        host = "0.0.0.0";
        port = 9120;
        public_url = "https://hermes.pertaka.duckdns.org";
      };
    };
  };
}


