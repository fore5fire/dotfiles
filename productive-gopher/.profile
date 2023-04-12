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
export GOPROXY="https://athens.admin.8labs.io/,direct"
export GONOSUMDB="code.8labs.io/*"

export GOENV_ROOT="$HOME/.goenv"
export PATH="$GOENV_ROOT/bin:$PATH"

# Setup Rust env
export PATH="$HOME/.cargo/bin:$PATH"

# Force programs to use wayland instead of xwayland
export MOZ_ENABLE_WAYLAND=1
export BEMENU_BACKEND=wayland
export GDK_BACKEND=wayland
export WLR_NO_HARDWARE_CURSORS=1

export BROWSER=qutebrowser

# Setup kubeconfig
export KUBECONFIG="$HOME/.kube/config:$HOME/.kube/config-dev-us-east-2-plt.yaml:$HOME/.kube/config-prod-us-east-2-plt.yaml"

#export VISUAL="alacritty -e vim"
export EDITOR="nvim"

alias E="alacritty -e ranger"

if test -z "${XDG_RUNTIME_DIR}"; then
	export XDG_RUNTIME_DIR=/tmp/${UID}-runtime-dir
	if ! test -d "${XDG_RUNTIME_DIR}"; then
		mkdir "${XDG_RUNTIME_DIR}"
		chmod 0700 "${XDG_RUNTIME_DIR}"
	fi
fi

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

