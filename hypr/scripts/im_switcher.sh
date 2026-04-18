#!/bin/bash

CONFIG_FILE="$HOME/.config/hypr/fcitx_apps.json"
SOCAT_SOCKET="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

# Hàm xử lý logic chuyển bộ gõ
handle_focus() {
  local win_class="$1"

  # Kiểm tra xem class có tồn tại trong mảng nào không
  if jq -e ".english | .[] | select(. == \"$win_class\")" "$CONFIG_FILE" >/dev/null; then
    fcitx5-remote -c
    # notify-send "Keyboard" "Switched to English ($win_class)" -t 1000 # Bật để test
  elif jq -e ".vietnamese | .[] | select(. == \"$win_class\")" "$CONFIG_FILE" >/dev/null; then
    fcitx5-remote -o
    # notify-send "Keyboard" "Switched to Vietnamese ($win_class)" -t 1000 # Bật để test
  fi
}

# Kiểm tra socat và file cấu hình
if ! command -v socat &>/dev/null || ! command -v jq &>/dev/null; then
  echo "Lỗi: Hãy cài đặt 'socat' và 'jq' trước."
  exit 1
fi

# Lắng nghe sự kiện từ Hyprland
socat -U - "UNIX-CONNECT:$SOCAT_SOCKET" | while read -r line; do
  # Chúng ta dùng sự kiện activewindow vì nó chứa sẵn tên class
  if [[ $line == activewindow\>\>* ]]; then
    window_info=${line#*>>}
    window_class=${window_info%%,*} # Lấy phần trước dấu phẩy

    handle_focus "$window_class"
  fi
done
