{
  flake.modules.nixos.nebula-dns =
  {
    pkgs,
    ...
  }:
  {
    services.resolved.enable = true;

    systemd.services."nebula@pertaka".serviceConfig = {
      ExecStartPost =
        let
          setupDns = pkgs.writeShellScript "nebula-pertaka-dns" ''
            ${pkgs.systemd}/bin/resolvectl dns nebula.pertaka 10.25.0.1
            ${pkgs.systemd}/bin/resolvectl domain nebula.pertaka '~pertaka.duckdns.org'
            ${pkgs.systemd}/bin/resolvectl default-route nebula.pertaka no
          '';
        in
        "+${setupDns}";

      ExecStopPost =
        "-+${pkgs.systemd}/bin/resolvectl revert nebula.pertaka";
    };
  };
}
