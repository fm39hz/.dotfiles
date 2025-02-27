#!/bin/bash

source "$HOME"/.config/hypr/lib.sh

manage_focus "Brave-browser-nightly" "brave-browser-nightly" "3" "true" "--enable-features=TouchpadOverscrollHistoryNavigation,vulkan,vulkanfromangle,defaultanglevulkan,vaapiignoredriverchecks,vaapivideodecoder,usemultiplaneformatforhardwarevideo,vaapivideoencoder --password-store=basic --enable-wayland-ime"
