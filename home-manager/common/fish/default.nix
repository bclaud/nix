{pkgs, lib, config, ...}: 
let
  packageNames = map (p: p.pname or p.name or null) config.home.packages;
  hasPackage = name: lib.any (x: x == name) packageNames;
  hasLazydocker = hasPackage "lazydocker";
  hasLazygit = hasPackage "lazygit";
  hasZellij = hasPackage "zellij";
  hasFoot = hasPackage "foot";
in
{
  home.packages = with pkgs; [
    fd 
    ripgrep
    ];

  programs.fish = {
    enable = true;

    shellAbbrs = {
      gc = "git checkout";
      gcb = "git checkout -b";
    };

    shellAliases = {
      mt = "mix test";
      g = "git";
      n = "nvim .";

      lzd = lib.mkIf hasLazydocker "lazydocker";
      lzg = lib.mkIf hasLazygit "lazygit";


      zj = lib.mkIf hasZellij "zellij";
      zje = lib.mkIf hasZellij "zellij run -- nvim .";

      ",," = "nix_run";
      ",." = "nix_shell_fish";
    };

    
    functions = {
      fish_greeting = "";

      nix_run = "nix run nixpkgs#$argv";

      nix_shell_fish = "nix shell nixpkgs#$argv -c fish";

      pythonEnv = {
        description = "start a nix-shell with given python packages";
        argumentNames = ["pythonVersion"];
        body = ''
        if set -q argv[2]
          set argv $argv[2..-1]
        end
      
        for el in $argv
          set ppkgs $ppkgs "python"$pythonVersion"Packages.$el"
        end
      
        nix-shell -p $ppkgs
        '';
      };

    };

    plugins = [
      {name = "sponge"; src = pkgs.fishPlugins.sponge.src;}
    ];

    # TODO this should be handled by yubikey-agent
    interactiveShellInit = ''
      set -x GPG_TTY (tty)
      set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
      gpgconf --launch gpg-agent
      
      update_cwd_osc
    '';

    shellInit = lib.mkIf hasFoot ''
          # Taken from https://codeberg.org/dnkl/foot/wiki#user-content-spawning-new-terminal-instances-in-the-current-working-directory
          function update_cwd_osc --on-variable PWD --description 'Notify terminals when $PWD changes'
            if status --is-command-substitution || set -q INSIDE_EMACS
                return
            end
            printf \e\]7\;file://%s%s\e\\ $hostname (string escape --style=url $PWD)
          end

          update_cwd_osc # Run once since we might have inherited PWD from a parent shell
      '';
  };

  programs.starship.enable = true;

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };
}
