function fish_greeting
    echo (set_color yellow; date +%T; set_color normal) $(whoami)@$(cat /etc/hostname)
end
