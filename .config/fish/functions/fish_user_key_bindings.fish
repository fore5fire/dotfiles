function fish_user_key_bindings
    fish_vi_key_bindings default
    for mode in default insert visual
        bind -M $mode \cc -m default 'echo; echo '^C'; commandline ""; commandline -f repaint'
    end
end
