{
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

            # The fork triggers Clippy warnings treated as errors
            # by the pinned Nixpkgs package.
            doCheck = false;
            preCheck = "";
          });
      })
    ];
  };
}