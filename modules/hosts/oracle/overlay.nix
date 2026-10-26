
{ inputs, ... }:

{
  flake-file.inputs.stcng-fix = {
    url = "git+https://tangled.org/r0chd.pl/switch-to-configuration-ng?rev=f66ae6aabc3da2cd292b791de1a3cd4a73ce3c73";
    flake = false;
  };

  flake.modules.nixos.stcng-fix =
    { ... }:
    {
      nixpkgs.overlays = [
        (final: prev: {
          switch-to-configuration-ng =
            prev.switch-to-configuration-ng.overrideAttrs (old: {
              src = inputs.stcng-fix;

              cargoDeps = final.rustPlatform.importCargoLock {
                lockFile = "${inputs.stcng-fix}/Cargo.lock";
              };

              cargoHash = null;

              # Avoid treating the fork's Clippy warnings as build failures.
              doCheck = false;
              preCheck = "";
            });
        })
      ];
    };
}
