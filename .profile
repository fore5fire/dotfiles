# Setup PATH
export PATH="$HOME/bin:$PATH"

# Use gnupg as the SSH agent
export GPG_TTY="$(tty)"
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent
echo UPDATESTARTUPTTY | gpg-connect-agent > /dev/null

# Setup Go env
export GOPATH="$HOME/.go"
export PATH="$GOPATH/bin:$PATH"

# Force programs to use wayland instead of xwayland
export MOZ_ENABLE_WAYLAND=1
export BEMENU_BACKEND=wayland
export GDK_BACKEND=wayland

#export VISUAL="alacritty -e vim"
export EDITOR="nvim"
alias vi="nvim"

alias E="alacritty -e ranger"

# Automatically start sway on TTY1
if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
	exec sway &> ~/.swaylog
fi

