function vi_mode_user_key_bindings
    bind \el suppress-autosuggestion
    bind -M insert jk "if commandline -P; commandline -f cancel; else; set fish_bind_mode default; commandline -f backward-char force-repaint; end"
    fish_vi_key_bindings --no-erase insert
    set -g fish_key_bindings fish_vi_key_bindings
    bind -M insert ctrl-c kill-whole-line repaint
end
