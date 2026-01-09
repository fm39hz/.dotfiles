import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Core
import qs.Services

Rectangle {
    id: mediaWidget

    required property var colors
    required property string fontFamily
    required property int fontSize
    required property var globalState
    property bool showInfo: false
    property bool hasMedia: MprisService.title !== ""
    property real componentsOpacity: showInfo ? 1 : 0

    Layout.preferredHeight: 28
    Layout.preferredWidth: showInfo ? Math.min(mediaContent.implicitWidth + 36, 300) : 28
    radius: 14 // Fully rounded
    color: showInfo ? Qt.rgba(0, 0, 0, 0.4) : "transparent"
    border.color: colors.accent
    border.width: (showInfo || MprisService.isPlaying) ? 1 : 0
    clip: true

    MouseArea {
        id: mediaMouse

        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        cursorShape: Qt.PointingHandCursor
        onClicked: (mouse) => {
            if (mouse.button === Qt.LeftButton)
                mediaWidget.globalState.requestInfoPanelTab(1);
            else if (mouse.button === Qt.RightButton)
                parent.showInfo = !parent.showInfo;
        }
    }

    Item {
        id: vinylContainer

        width: 24
        height: 24
        anchors.left: parent.left
        anchors.leftMargin: 2
        anchors.verticalCenter: parent.verticalCenter

        Rectangle {
            anchors.fill: parent
            radius: 12
            color: "#1a1a1a"
            border.color: colors.accent
            border.width: 1

            Image {
                anchors.fill: parent
                anchors.margins: 2
                source: MprisService.artUrl !== "" ? MprisService.artUrl : "../../../Assets/music.svg"
                fillMode: Image.PreserveAspectCrop
                layer.enabled: true

                layer.effect: OpacityMask {

                    maskSource: Rectangle {
                        width: 20
                        height: 20
                        radius: 10
                    }

                }

            }

            Rectangle {
                width: 6
                height: 6
                radius: 3
                color: "#2a2a2a"
                anchors.centerIn: parent
                border.color: "#000000"
                border.width: 1
            }

        }

        RotationAnimation on rotation {
            from: 0
            to: 360
            duration: 4000
            loops: Animation.Infinite
            running: MprisService.isPlaying
        }

    }

    RowLayout {
        id: mediaContent

        anchors.left: vinylContainer.right
        anchors.leftMargin: 12
        anchors.verticalCenter: parent.verticalCenter
        spacing: 12
        opacity: mediaWidget.componentsOpacity
        visible: opacity > 0

        Text {
            text: {
                let t = MprisService.title !== "" ? MprisService.title : "No Media";
                let a = MprisService.artist;
                if (a !== "" && a !== "Unknown Artist")
                    return t + " • " + a;

                return t;
            }
            font.family: fontFamily
            font.pixelSize: fontSize - 1
            font.bold: true
            color: colors.fg
            elide: Text.ElideRight
            Layout.fillWidth: true
            Layout.maximumWidth: 160
            Layout.alignment: Qt.AlignVCenter
            verticalAlignment: Text.AlignVCenter
        }

        Behavior on opacity {
            NumberAnimation {
                duration: Animations.fast
            }

        }

    }

    Behavior on Layout.preferredWidth {
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

    Behavior on border.width {
        NumberAnimation {
            duration: Animations.fast
        }

    }

}
