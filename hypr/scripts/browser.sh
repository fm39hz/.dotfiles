#!/bin/bash

source "$HOME"/.config/hypr/lib.sh

# manage_focus "Brave-browser-nightly" "brave-browser-nightly" "4" "true" "--enable-features=TouchpadOverscrollHistoryNavigation,vulkan,vulkanfromangle,defaultanglevulkan,vaapiignoredriverchecks,vaapivideodecoder,usemultiplaneformatforhardwarevideo,vaapivideoencoder --password-store=basic --enable-wayland-ime"
manage_focus "Microsoft-edge" "microsoft-edge-stable" "4" "--enable-features=UseOzonePlatform --ozone-platform=wayland"
# manage_focus "Zen Browser" "zen-browser" "4"
