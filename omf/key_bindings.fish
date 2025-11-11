bind ctrl-b '
    if test -z "$TMUX"
    ~/.config/scripts/tmux_project.sh $argv 
    end
    ' repaint
