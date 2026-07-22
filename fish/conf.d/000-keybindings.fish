function fish_user_key_bindings
    for mode in insert default visual
        bind -M $mode \cp up-or-search
        bind -M $mode \cn down-or-search
        bind -M $mode \cb "$HOME/go/bin/gotomux"
        bind -M $mode \cy 'yazi; commandline -f repaint'
        bind -M $mode \el 'clear; commandline -f repaint'
        bind -M $mode \eu '
            clear
            ~/.config/scripts/system_update.sh
        '
    end
end
