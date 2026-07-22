if status is-interactive
    string match -q "$TERM_PROGRAM" "kiro" && . (kiro --locate-shell-integration-path fish)
end
