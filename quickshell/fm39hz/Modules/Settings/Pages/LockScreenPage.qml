import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.Core
import qs.Services
import qs.Widgets

ColumnLayout {
    property var context // Injected context
    property var colors: context.colors

    spacing: 16

    Text {
        text: "Lock Screen"
        font.family: Config.fontFamily
        font.pixelSize: 20
        font.bold: true
        color: colors.fg
    }

    ToggleButton {
        Layout.fillWidth: true
        label: "Lock Screen Blur"
        sublabel: "Enable blur effect on lock screen"
        icon: "󰂚"
        active: !Config.disableLockBlur
        colors: context.colors
        onActiveChanged: {
            if (active !== !Config.disableLockBlur)
                Config.disableLockBlur = !active;

        }
        enabled: Config.lockScreenCustomBackground
        opacity: enabled ? 1 : 0.5
    }

    ToggleButton {
        Layout.fillWidth: true
        label: "Lock Screen Animation"
        sublabel: "Enable startup animation on lock screen"
        icon: "󰑮"
        active: !Config.disableLockAnimation
        colors: context.colors
        onActiveChanged: {
            if (active !== !Config.disableLockAnimation)
                Config.disableLockAnimation = !active;

        }
    }

    ToggleButton {
        Layout.fillWidth: true
        label: "Wallpaper Only Lockscreen"
        sublabel: "Show only wallpaper (hide windows/bar)"
        icon: "󰸉"
        active: Config.lockScreenCustomBackground
        colors: context.colors
        onActiveChanged: {
            if (active !== Config.lockScreenCustomBackground)
                Config.lockScreenCustomBackground = active;

        }
    }

    ToggleButton {
        Layout.fillWidth: true
        label: "Music Mode"
        sublabel: "Show simplified music player on lock screen"
        icon: "󰎈"
        active: Config.lockScreenMusicMode
        colors: context.colors
        onActiveChanged: {
            if (active !== Config.lockScreenMusicMode)
                Config.lockScreenMusicMode = active;

        }
    }

}
