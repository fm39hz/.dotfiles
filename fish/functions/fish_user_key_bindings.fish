function fish_user_key_bindings
    bind \e\e thefuck-command-line
    bind -M insert jk "if commandline -P; commandline -f cancel; else; set fish_bind_mode default; commandline -f backward-char force-repaint; end"
    fish_vi_key_bindings --no-erase insert
end
