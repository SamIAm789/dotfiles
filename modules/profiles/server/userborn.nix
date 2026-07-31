{
  flake.modules.nixos.server-profile = {
  
    services.userborn.passwordFilesLocation = "/persist/userborn";

    preservation.preserveAt."/persist" = {
      directories = [
        "/userborn"
      ];
    };
  };
}