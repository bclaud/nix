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

alias n="nvim"

alias zj="zellij"
alias zje="zellij run -- nvim ."
