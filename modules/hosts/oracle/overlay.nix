(final: prev: {
  switch-to-configuration-ng =
    prev.switch-to-configuration-ng.overrideAttrs (old: {
      src = inputs.stcng-fix;

      cargoDeps = prev.rustPlatform.importCargoLock {
        lockFile = "${inputs.stcng-fix}/Cargo.lock";
      };
    });
})