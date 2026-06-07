-- Some default env vars.
hl.env("XCURSOR_SIZE", "32")
hl.env("WLR_NO_HARDWARE_CURSORS", "1")
hl.env("HYPRCURSOR_THEME", "everforest-cursors")
hl.env("HYPRCURSOR_SIZE", "32")

-- input
hl.env("XMODIFIERS", "@im=wayland")
hl.env("_JAVA_AWT_WM_NONREPARENTING", "1")
hl.env("GTK_IM_MODULE", "")

-- wayland
hl.env("QT_QPA_PLATFORMTHEME", "gtk3")
-- hl.env("NVD_BACKEND", "direct")
hl.env("MOZ_ENABLE_WAYLAND", "1")
-- hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("QT_IM_MODULE", "wayland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "hyprland")
hl.env("GDK_BACKEND", "wayland,x11")
hl.env("QT_QPA_PLATFORM", "wayland")

-- gpu
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("NVD_BACKEND", "direct")
-- hl.env("AQ_DRM_DEVICES", "/dev/dri/card2:/dev/dri/card2:/dev/dri/card1")
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("GBM_BACKEND", "nvidia-drm")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
