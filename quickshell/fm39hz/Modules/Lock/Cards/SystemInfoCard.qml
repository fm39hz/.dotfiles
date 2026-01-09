import "../Components"
import QtQuick
import QtQuick.Layouts
import Quickshell

BentoCard {
    id: root

    required property var colors

    cardColor: colors.surface
    borderColor: colors.border

    RowLayout {
        anchors.centerIn: parent
        spacing: 24

        Text {
            text: "󰣇"
            font.family: "Symbols Nerd Font"
            font.pixelSize: 100
            color: root.colors.accent
        }

        ColumnLayout {
            spacing: 5

            Text {
                text: Quickshell.env("USER") + "@archbtw"
                font.weight: Font.Bold
                font.pixelSize: 16
                color: root.colors.accent
                font.family: "JetBrainsMono Nerd Font"
                Layout.bottomMargin: 4
            }

            Rectangle {
                Layout.preferredWidth: 180
                Layout.preferredHeight: 2
                color: root.colors.subtext
                opacity: 0.4
                Layout.bottomMargin: 4
            }

            Repeater {
                model: [{
                    "label": "OS",
                    "value": "Arch Linux",
                    "icon": "",
                    "color": root.colors.blue
                }, {
                    "label": "Host",
                    "value": "archbtw",
                    "icon": "",
                    "color": root.colors.purple
                }, {
                    "label": "Kernel",
                    "value": "6.18.2-arch2-1",
                    "icon": "",
                    "color": root.colors.green
                }, {
                    "label": "Uptime",
                    "value": "3 hours",
                    "icon": "",
                    "color": root.colors.yellow
                }, {
                    "label": "Shell",
                    "value": "zsh",
                    "icon": "",
                    "color": root.colors.orange
                }, {
                    "label": "WM",
                    "value": "Hyprland",
                    "icon": "",
                    "color": root.colors.red
                }]

                RowLayout {
                    required property var modelData

                    spacing: 10

                    Text {
                        text: modelData.icon
                        color: modelData.color
                        font.family: "Symbols Nerd Font"
                        font.pixelSize: 13
                    }

                    Text {
                        text: modelData.label + ":"
                        color: modelData.color
                        font.weight: Font.Bold
                        font.pixelSize: 13
                        font.family: "JetBrainsMono Nerd Font"
                    }

                    Text {
                        text: modelData.value
                        color: root.colors.fg
                        font.pixelSize: 13
                        font.family: "JetBrainsMono Nerd Font"
                    }

                }

            }

            RowLayout {
                spacing: 5
                Layout.topMargin: 8

                Repeater {
                    model: [root.colors.red, root.colors.green, root.colors.yellow, root.colors.blue, root.colors.purple, root.colors.teal]

                    Rectangle {
                        required property color modelData

                        width: 22
                        height: 11
                        radius: 2
                        color: modelData
                    }

                }

            }

        }

    }

}
