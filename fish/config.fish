if status is-interactive
end

# Added by LM Studio CLI tool (lms)
set -gx PATH $PATH /home/fm39hz/.cache/lm-studio/bin

string match -q "$TERM_PROGRAM" "kiro" and . (kiro --locate-shell-integration-path fish)


# Added by Antigravity CLI installer
set -gx PATH "/home/fm39hz/.local/bin" $PATH
