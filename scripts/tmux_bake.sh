#!/bin/bash
# Lấy tên session hiện tại
SESSION=$(tmux display-message -p '#S')
# Đường dẫn lưu file
OUT="$HOME/.config/tmuxp/$SESSION.yml"

echo "Baking session: $SESSION int $OUT"
# Thực hiện nướng
tmuxp freeze --save-to "$OUT" --force --yes "$SESSION" >/dev/null 2>&1

if [ $? -eq 0 ]; then
  tmux display-message "󱔐 Session $SESSION Baked!"
else
  tmux display-message "󰚌 Bake failed!"
fi
