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

    bass source "$HOME/.profile"

    alias E="alacritty -e ranger"

    alias sudo="doas"

    alias vpnstart="pritunl-client start o9lo8fxves3wwmutkreyzevccwssn8ic --password"
    alias vpnstop="pritunl-client stop o9lo8fxves3wwmutkreyzevccwssn8ic"
    alias vpnls="pritunl-client list"

    # Create command shortcuts
    alias k="kubectl"
    alias kgp="kubectl get pods"
    alias kpf="kubectl port-forward"
    alias kcu="kubectl config use-context"
    alias kcn="kubectl config set-context --current --namespace"
    alias es="source ~/.zshrc"
    alias ec="$EDITOR ~/.zshrc"
    alias uuid="uuidgen | tr '[:upper:]' '[:lower:]'"
    alias ls="eza"
    alias v="vi"


    # Automatically start sway on TTY1
    if test -z $DISPLAY && test "$(tty)" = "/dev/tty1"
	if which dbus-launch &> /dev/null && test -z "$DBUS_SESSION_BUS_ADDRESS"
		bass (dbus-launch --sh-syntax --exit-with-session)
	end
        exec sway &> ~/.swaylog
    end

end
