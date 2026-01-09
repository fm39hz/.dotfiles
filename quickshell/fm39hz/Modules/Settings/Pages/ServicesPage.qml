import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.Core
import qs.Services
import qs.Widgets

ColumnLayout {
    property var context
    property var colors: context.colors

    spacing: 16

    Text {
        text: "Services"
        font.family: Config.fontFamily
        font.pixelSize: 20
        font.bold: true
        color: colors.fg
    }

    ToggleButton {
        Layout.fillWidth: true
        label: "Debug Mode"
        sublabel: "Enable verbose logging"
        icon: "󰃤"
        active: Config.debug
        colors: context.colors
        onActiveChanged: {
            if (Config.debug !== active)
                Config.debug = active;

        }
    }

    Rectangle {
        id: openRgbCard

        property bool expanded: false

        Layout.fillWidth: true
        implicitHeight: layout.implicitHeight + 32
        radius: 12
        color: colors.surface
        clip: true

        ColumnLayout {
            id: layout

            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 16
            spacing: 16

            RowLayout {
                Layout.fillWidth: true
                spacing: 16

                Rectangle {
                    Layout.preferredWidth: 40
                    Layout.preferredHeight: 40
                    radius: 10
                    color: Qt.rgba(colors.accent.r, colors.accent.g, colors.accent.b, 0.1)

                    Text {
                        anchors.centerIn: parent
                        text: "󰌌"
                        font.family: "Symbols Nerd Font"
                        font.pixelSize: 20
                        color: colors.accent
                    }

                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2

                    Text {
                        text: "OpenRGB Devices"
                        font.pixelSize: 14
                        font.weight: Font.Medium
                        color: colors.fg
                        Layout.fillWidth: true
                    }

                    Text {
                        text: openRgbCard.expanded ? "Tap to collapse" : "Tap to expand and configure"
                        font.pixelSize: 12
                        color: colors.muted
                        Layout.fillWidth: true
                    }

                }

                Text {
                    text: openRgbCard.expanded ? "󰅃" : "󰅀"
                    font.family: "Symbols Nerd Font"
                    font.pixelSize: 20
                    color: colors.muted

                    RotationAnimation on rotation {
                        from: openRgbCard.expanded ? 0 : 180
                        to: openRgbCard.expanded ? 180 : 0
                        duration: 200
                        running: false
                    }

                }

                TapHandler {
                    onTapped: openRgbCard.expanded = !openRgbCard.expanded
                    cursorShape: Qt.PointingHandCursor
                }

            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color: colors.border
                visible: openRgbCard.expanded
                opacity: openRgbCard.expanded ? 1 : 0

                Behavior on opacity {
                    NumberAnimation {
                        duration: 200
                    }

                }

            }

            ColumnLayout {
                visible: openRgbCard.expanded
                opacity: openRgbCard.expanded ? 1 : 0
                Layout.fillWidth: true
                spacing: 8

                Repeater {
                    model: WallpaperService.availableOpenRgbDevices

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 48
                        color: Qt.rgba(colors.surface.r, colors.surface.g, colors.surface.b, 0.5)
                        radius: 8
                        border.color: colors.border
                        border.width: 1

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 12
                            spacing: 12

                            Text {
                                text: "󰍜" // Generic device icon
                                font.family: "Symbols Nerd Font"
                                font.pixelSize: 16
                                color: colors.accent
                            }

                            Text {
                                text: modelData.name
                                color: colors.fg
                                font.pixelSize: 13
                                Layout.fillWidth: true
                                elide: Text.ElideRight
                            }

                            CheckBox {
                                checked: Config.openRgbDevices && Config.openRgbDevices.includes(modelData.id)
                                palette.mid: colors.border
                                palette.text: colors.fg
                                palette.base: colors.bg
                                palette.window: colors.bg
                                onToggled: {
                                    var current = Config.openRgbDevices ? Config.openRgbDevices.slice() : [];
                                    var idx = current.indexOf(modelData.id);
                                    if (checked && idx === -1)
                                        current.push(modelData.id);
                                    else if (!checked && idx !== -1)
                                        current.splice(idx, 1);
                                    current.sort((a, b) => {
                                        return a - b;
                                    });
                                    Config.openRgbDevices = current;
                                }
                            }

                        }

                    }

                }

                Text {
                    visible: WallpaperService.availableOpenRgbDevices.length === 0
                    text: "No supported devices found"
                    color: colors.muted
                    font.italic: true
                    font.pixelSize: 13
                    Layout.leftMargin: 4
                }

                Button {
                    text: "Refresh Devices"
                    onClicked: WallpaperService.refreshOpenRgbDevices()
                    Layout.topMargin: 4
                    Layout.fillWidth: true

                    background: Rectangle {
                        color: parent.down ? Qt.rgba(colors.accent.r, colors.accent.g, colors.accent.b, 0.2) : "transparent"
                        border.color: colors.border
                        border.width: 1
                        radius: 8
                    }

                    contentItem: Text {
                        text: parent.text
                        color: colors.fg
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                }

                Behavior on opacity {
                    NumberAnimation {
                        duration: 200
                    }

                }

            }

        }

        Behavior on implicitHeight {
            NumberAnimation {
                duration: 200
                easing.type: Easing.InOutQuad
            }

        }

    }

}
