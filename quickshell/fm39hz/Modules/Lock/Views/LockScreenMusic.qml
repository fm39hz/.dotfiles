import "../Cards"
import "../Components"
import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.Core
import qs.Services

Item {
    id: root

    required property var colors
    required property var pam
    property alias inputField: musicPwd.inputField

    Item {
        property string currentArt: MprisService.artUrl

        anchors.fill: parent
        layer.enabled: true
        onCurrentArtChanged: {
            if (currentArt === "")
                return ;

            if (img1.opacity > 0)
                img2.source = currentArt;
            else
                img1.source = currentArt;
        }

        Rectangle {
            anchors.fill: parent
            color: "#000000"
        }

        Image {
            anchors.fill: parent
            source: Config.lockScreenCustomBackground ? ("file://" + WallpaperService.getWallpaper(Quickshell.screens[0].name)) : ""
            fillMode: Image.PreserveAspectCrop
            visible: true
            layer.enabled: true

            layer.effect: FastBlur {
                radius: 64
                transparentBorder: false
            }

        }

        Image {
            id: img1

            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
            Component.onCompleted: source = MprisService.artUrl
            onStatusChanged: {
                if (status === Image.Ready && opacity === 0 && source == parent.currentArt)
                    crossfadeTo1.start();

            }
        }

        Image {
            id: img2

            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
            opacity: 0
            onStatusChanged: {
                if (status === Image.Ready && opacity === 0 && source == parent.currentArt)
                    crossfadeTo2.start();

            }
        }

        ParallelAnimation {
            id: crossfadeTo2

            NumberAnimation {
                target: img2
                property: "opacity"
                to: 1
                duration: Config.disableLockAnimation ? 0 : 1000
                easing.type: Easing.OutQuad
            }

            NumberAnimation {
                target: img1
                property: "opacity"
                to: 0
                duration: Config.disableLockAnimation ? 0 : 1000
                easing.type: Easing.OutQuad
            }

        }

        ParallelAnimation {
            id: crossfadeTo1

            NumberAnimation {
                target: img1
                property: "opacity"
                to: 1
                duration: Config.disableLockAnimation ? 0 : 1000
                easing.type: Easing.OutQuad
            }

            NumberAnimation {
                target: img2
                property: "opacity"
                to: 0
                duration: Config.disableLockAnimation ? 0 : 1000
                easing.type: Easing.OutQuad
            }

        }

        layer.effect: FastBlur {
            radius: 64
            transparentBorder: false
        }

    }

    Item {
        anchors.fill: parent
        z: 100

        ColumnLayout {
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -100 // Further lift content
            spacing: 0 // Remove gap between clock and date, and other items

            Column {
                Layout.alignment: Qt.AlignHCenter
                spacing: -80 // Move minutes UP even more

                Text {
                    text: {
                        let h = new Date().getHours() % 12 || 12;
                        return h.toString().padStart(2, '0');
                    }
                    font.family: "StretchPro"
                    font.pixelSize: 200
                    font.weight: Font.Bold
                    color: "#FFFFFF"
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.horizontalCenterOffset: -80 // Shift Left (One's place centered)
                    layer.enabled: true

                    layer.effect: DropShadow {
                        transparentBorder: true
                        radius: 16
                        samples: 16
                        color: "#80000000"
                    }

                }

                Text {
                    text: Qt.formatTime(new Date(), "mm")
                    font.family: "StretchPro"
                    font.pixelSize: 200
                    font.weight: Font.Bold
                    color: "#93C4FF"
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.horizontalCenterOffset: 80 // Shift Right (Ten's place centered)
                    layer.enabled: true

                    layer.effect: DropShadow {
                        transparentBorder: true
                        radius: 16
                        samples: 16
                        color: "#80000000"
                    }

                }

            }

            Text {
                text: Qt.formatDate(new Date(), "d MMMM, ddd.")
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 24
                font.weight: Font.Medium
                color: root.colors.fg
                opacity: 0.7
                Layout.alignment: Qt.AlignHCenter
                layer.enabled: true

                layer.effect: DropShadow {
                    transparentBorder: true
                    radius: 8
                    samples: 16
                    color: "#80000000"
                }

            }

            Item {
                Layout.preferredHeight: 32
            }

            ColumnLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 8

                Text {
                    text: MprisService.title || "No Media Playing"
                    font.family: Config.fontFamily
                    font.pixelSize: 32
                    font.weight: Font.Bold
                    color: root.colors.fg
                    Layout.alignment: Qt.AlignHCenter
                    Layout.maximumWidth: 800
                    elide: Text.ElideRight
                    layer.enabled: true

                    layer.effect: DropShadow {
                        transparentBorder: true
                        radius: 12
                        samples: 16
                        color: "#80000000"
                    }

                }

                Text {
                    text: MprisService.artist || "Unknown Artist"
                    font.family: Config.fontFamily
                    font.pixelSize: 20
                    color: root.colors.fg
                    opacity: 0.8
                    Layout.alignment: Qt.AlignHCenter
                    Layout.maximumWidth: 600
                    elide: Text.ElideRight
                    layer.enabled: true

                    layer.effect: DropShadow {
                        transparentBorder: true
                        radius: 8
                        samples: 16
                        color: "#80000000"
                    }

                }

            }

            Item {
                Layout.preferredHeight: 32
            }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 32 // Reduced spacing between buttons

                Text {
                    text: "󰒮"
                    font.family: "Symbols Nerd Font"
                    font.pixelSize: 32 // Smaller prev icon (was 48)
                    color: root.colors.fg
                    opacity: prevMouse.containsMouse ? 1 : 0.7
                    layer.enabled: true

                    MouseArea {
                        id: prevMouse

                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: MprisService.previous()
                    }

                    Behavior on opacity {
                        NumberAnimation {
                            duration: 150
                        }

                    }

                    layer.effect: DropShadow {
                        transparentBorder: true
                        radius: 8
                        samples: 16
                        color: "#80000000"
                    }

                }

                Rectangle {
                    width: 64 // Smaller button (was 96)
                    height: 64
                    radius: 32
                    color: root.colors.accent
                    layer.enabled: true

                    Text {
                        anchors.centerIn: parent
                        text: MprisService.isPlaying ? "󰏤" : "󰐊"
                        font.family: "Symbols Nerd Font"
                        font.pixelSize: 28 // Smaller play icon (was 42)
                        color: root.colors.bg
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: MprisService.playPause()
                        onPressed: parent.scale = 0.9
                        onReleased: parent.scale = 1
                    }

                    Behavior on scale {
                        NumberAnimation {
                            duration: 100
                            easing.type: Easing.OutQuad
                        }

                    }

                    layer.effect: DropShadow {
                        transparentBorder: true
                        radius: 12 // Reduced shadow radius
                        samples: 16
                        color: "#60000000"
                    }

                }

                Text {
                    text: "󰒭"
                    font.family: "Symbols Nerd Font"
                    font.pixelSize: 32 // Smaller next icon (was 48)
                    color: root.colors.fg
                    opacity: nextMouse.containsMouse ? 1 : 0.7
                    layer.enabled: true

                    MouseArea {
                        id: nextMouse

                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: MprisService.next()
                    }

                    Behavior on opacity {
                        NumberAnimation {
                            duration: 150
                        }

                    }

                    layer.effect: DropShadow {
                        transparentBorder: true
                        radius: 8
                        samples: 16
                        color: "#80000000"
                    }

                }

            }

        }

        PasswordCard {
            id: musicPwd

            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: 40
            width: 320
            height: 110 // Sufficient height for Avatar + Input
            colors: root.colors
            pam: root.pam
            visible: true
            opacity: 0.9
            cardColor: Qt.rgba(0, 0, 0, 0.5)
            borderColor: Qt.rgba(1, 1, 1, 0.1)
        }

    }

}
