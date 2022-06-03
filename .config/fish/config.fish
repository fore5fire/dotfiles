if status is-interactive

    zoxide init --hook=pwd fish | source

    function cpass
        lpass show --password $argv | wl-copy
    end

    # Switch to normal mode after every newline
    function set_normal_mode --on-event fish_prompt
      set fish_bind_mode default
    end

    # Emulates vim's cursor shape behavior
    # Set the normal and visual mode cursors to a block
    set fish_cursor_default block
    # Set the insert mode cursor to a line
    set fish_cursor_insert line
    # Set the replace mode cursor to an underscore
    set fish_cursor_replace_one underscore
    # The following variable can be used to configure cursor shape in
    # visual mode, but due to fish_cursor_default, is redundant here
    set fish_cursor_visual block

    # Setup PATH
    export PATH="$HOME/.bin:$HOME/.cargo/bin:$PATH"

    # Use gnupg as the SSH agent
    export GPG_TTY="$(tty)"
    #export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    gpgconf --launch gpg-agent
    echo UPDATESTARTUPTTY | gpg-connect-agent > /dev/null

    # Setup Go env
    export GOPATH="$HOME/.go"
    export PATH="$GOPATH/bin:$PATH"
    export GOPROXY="https://athens.admin.8labs.io/,direct"
    export GONOSUMDB="code.8labs.io/*"

    export BROWSER=qutebrowser

    # Force programs to use wayland instead of xwayland
    export MOZ_ENABLE_WAYLAND=1
    export BEMENU_BACKEND=wayland
    export WLR_NO_HARDWARE_CURSORS=1

    #export VISUAL="alacritty -e vim"
    export EDITOR="nvim"
    alias vi="nvim"

    alias E="alacritty -e ranger"

    alias vpnstart="pritunl-client start o9lo8fxves3wwmutkreyzevccwssn8ic --password"
    alias vpnstop="pritunl-client stop o9lo8fxves3wwmutkreyzevccwssn8ic"
    alias vpnls="pritunl-client list"
    # Setup go
    export PATH="$PATH:$HOME/go/bin:$HOME/bin"

    # Set PATH so it includes user's private bin if it exists
    export PATH="$HOME/bin:$PATH"

    # Setup kubeconfig
    export KUBECONFIG="$HOME/.kube/config:$HOME/.kube/config-dev-us-east-2-plt.yaml:$HOME/.kube/config-prod-us-east-2-plt.yaml"

    # Create command shortcuts
    alias k="kubectl"
    alias kgp="kubectl get pods"
    alias kpf="kubectl port-forward"
    alias kcu="kubectl config use-context"
    alias kcn="kubectl config set-context --current --namespace"
    alias es="source ~/.zshrc"
    alias ec="$EDITOR ~/.zshrc"
    alias uuid="uuidgen | tr '[:upper:]' '[:lower:]'"
    alias ls="exa"

    # Automatically start sway on TTY1
    if test -z $DISPLAY && test "$(tty)" = "/dev/tty1"
        exec sway &> ~/.swaylog
    end

end
