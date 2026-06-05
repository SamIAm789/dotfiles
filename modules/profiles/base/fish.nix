{
  flake.modules.nixos.fish =
    {
      pkgs,
      ...
    }:
    {

      programs.fish.enable = true;

      # The following allows the use of fish by default, upon login or on starting a terminal emulator. This solution uses ~/.bashrc as a wrapper to have fish inherit the environment from the login shell, which is left as Bash.
      # Prevents issues when using login shells (as fish is not POSIX compliant).

      programs.bash = {
        interactiveShellInit = ''
          if [[ $USER = "sam" ]]; then
            if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
            then
              shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
              exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
            fi
          fi
        '';
      };

    };
}
