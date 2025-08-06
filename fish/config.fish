if status is-interactive
end

zoxide init fish | source
fish_add_path /home/fm39hz/.spicetify

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /home/fm39hz/.cache/lm-studio/bin

thefuck --alias | source

alias claude="/home/fm39hz/.claude/local/claude"
