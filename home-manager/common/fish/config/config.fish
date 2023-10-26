set fish_greeting " Praise the sun "

# this should be handled by yubikey-agent, not here. But is probably conflicting

set -x GPG_TTY (tty)
set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent

#starship
starship init fish | source

# Z
zoxide init fish | source

#aliases
alias mt="mix test"

alias g="git"

alias lzd="lazydocker"
alias lzg="lazygit"

alias n="nvim ."

alias zj="zellij"
alias zje="zellij run -- nvim ."

function nix_run
	nix run nixpkgs#$argv
end

alias ,,=nix_run

function nix_shell_fish
	nix shell nixpkgs#$argv -c fish
end

alias ,.=nix_shell_fish

function pythonEnv --description 'start a nix-shell with the given python packages' --argument pythonVersion
  if set -q argv[2]
    set argv $argv[2..-1]
  end
 
  for el in $argv
    set ppkgs $ppkgs "python"$pythonVersion"Packages.$el"
  end
 
  nix-shell -p $ppkgs
end

