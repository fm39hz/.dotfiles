import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import qs.Core
import qs.Widgets
import qs.Widgets

RowLayout {
    id: root

    required property var colors
    property bool trayOpen: false

    visible: SystemTray.items.values.length > 0
    spacing: 2

    Rectangle {
        clip: true
        height: 26
        radius: height / 2
        color: Qt.rgba(0, 0, 0, 0.2)
        border.color: colors.muted
        border.width: 1
        Layout.preferredWidth: trayOpen ? (trayInner.implicitWidth + 16) : 0
        Layout.rightMargin: trayOpen ? 4 : 0
        opacity: trayOpen ? 1 : 0

        RowLayout {
            id: trayInner

            anchors.centerIn: parent
            spacing: 8

            Tray {
                borderColor: "transparent"
                itemHoverColor: colors.accent
                iconSize: 16
                colors: root.colors
            }

        }

        Behavior on Layout.preferredWidth {
            NumberAnimation {
                duration: Animations.medium
                easing.type: Animations.standardEasing
            }

        }

        Behavior on Layout.rightMargin {
            NumberAnimation {
                duration: Animations.medium
                easing.type: Animations.standardEasing
            }

        }

        Behavior on opacity {
            NumberAnimation {
                duration: Animations.fast
            }

        }

    }

    Rectangle {
        Layout.preferredWidth: 26
        Layout.preferredHeight: 26
        radius: height / 2
        color: trayOpen ? colors.accent : "transparent"
        border.color: colors.muted
        border.width: 1

        Icon {
            anchors.centerIn: parent
            icon: Icons.arrowLeft
            font.pixelSize: 14
            color: trayOpen ? colors.bg : colors.fg
            rotation: trayOpen ? 180 : 0

            Behavior on rotation {
                NumberAnimation {
                    duration: Animations.medium
                    easing.type: Animations.enterEasing
                }

            }

            Behavior on color {
                ColorAnimation {
                    duration: Animations.fast
                }

            }

        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            onClicked: parent.parent.trayOpen = !parent.parent.trayOpen
            onEntered: parent.border.color = colors.accent
            onExited: parent.border.color = colors.muted
        }

        Behavior on color {
            ColorAnimation {
                duration: Animations.fast
            }

        }

        Behavior on border.color {
            ColorAnimation {
                duration: Animations.fast
            }

        }

    }

}
