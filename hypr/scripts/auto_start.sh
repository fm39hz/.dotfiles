#!/usr/bin/env bash

# Bar
~/.config/quickshell/run.fish &

# Chạy các service nền trước
lxsession &
fcitx5 -d &
hyprpaper &
hypridle &
hyprsunset &

# --- PHẦN MỒI PERFORMANCE ---
# Lấy đường dẫn vendor của Nushell
NU_VENDOR_DIR=$(nu -c 'print ($nu.data-dir | path join "vendor/autoload")')
mkdir -p "$NU_VENDOR_DIR"

# Mồi Sesh
sesh list >/dev/null 2>&1 &

# Xuất script tĩnh cho Starship và Zoxide vào thư mục autoload
# Nushell sẽ tự động nạp các file này mà không cần lệnh 'source' trong config.nu
starship init nu >"$NU_VENDOR_DIR/starship.nu" &
zoxide init nushell >"$NU_VENDOR_DIR/zoxide.nu" &

# Mồi cache render Starship
STARSHIP_SHELL="nu" starship prompt --status=0 >/dev/null 2>&1 &
# ----------------------------

# Đợi một chút cho hệ thống ổn định rồi chạy các app nặng hơn
sleep 1
ghostty --quit-after-last-window-closed=false --initial-window=false &
solaar --window=hide &
localsend --hidden &
mangohud steam -silent &

# Các script ứng dụng
~/.config/hypr/scripts/chat.sh
~/.config/hypr/scripts/browser.sh
~/.config/hypr/scripts/note.sh
hyprctl dispatch workspace 2
