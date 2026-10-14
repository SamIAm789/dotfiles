{
  flake.modules.nixos.openssh-vps = {

     services.openssh = {
       enable = true;
      openFirewall = false;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "prohibit-password";
        MaxAuthTries = 3;
      };
    };
      networking.firewall.interfaces."nebula.pertaka".allowedTCPPorts = [ 22 ];
  };
}