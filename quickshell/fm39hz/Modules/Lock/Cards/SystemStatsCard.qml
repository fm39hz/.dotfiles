import "../Components"
import QtQuick
import QtQuick.Layouts
import qs.Services

BentoCard {
    id: root

    required property var colors

    cardColor: colors.surface
    borderColor: colors.border

    DiskService {
        id: disk
    }

    VolumeService {
        id: volume
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 14
        spacing: 14

        ProgressRing {
            Layout.fillWidth: true
            Layout.fillHeight: true
            value: disk.usage / 100
            icon: "󰋊"
            accentColor: "#89DCEB"
            colors: root.colors
        }

        ProgressRing {
            Layout.fillWidth: true
            Layout.fillHeight: true
            value: volume.volume
            icon: "󰕾"
            accentColor: "#CBA6F7"
            colors: root.colors
        }

        ProgressRing {
            Layout.fillWidth: true
            Layout.fillHeight: true
            value: BatteryService.percentage / 100
            icon: BatteryService.charging ? "󰂄" : "󰁹"
            accentColor: "#A6E3A1"
            colors: root.colors
        }

        ProgressRing {
            Layout.fillWidth: true
            Layout.fillHeight: true
            value: BrightnessService.brightness
            icon: "󰃠"
            accentColor: "#F9E2AF"
            colors: root.colors
        }

    }

}
