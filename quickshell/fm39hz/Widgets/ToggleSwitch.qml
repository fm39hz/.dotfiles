import QtQuick
import QtQuick.Controls

Item {
    id: root

    property bool checked: false
    property var colors: null
    property color activeColor: colors ? colors.accent : "#CBA6F7"
    property color inactiveColor: colors ? colors.surface : "#313244"
    property color thumbColor: colors ? colors.fg : "#CDD6F4"

    implicitWidth: 44
    implicitHeight: 24

    Rectangle {
        id: track

        anchors.fill: parent
        radius: height / 2
        color: root.checked ? root.activeColor : root.inactiveColor
        border.width: 1
        border.color: root.checked ? root.activeColor : (colors ? colors.border : "#45475A")

        Rectangle {
            id: thumb

            width: parent.height - 4
            height: width
            radius: width / 2
            anchors.verticalCenter: parent.verticalCenter
            x: root.checked ? parent.width - width - 2 : 2
            color: root.thumbColor

            Behavior on x {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutQuad
                }

            }

        }

        Behavior on color {
            ColorAnimation {
                duration: 200
            }

        }

    }

    TapHandler {
        onTapped: root.checked = !root.checked
        cursorShape: Qt.PointingHandCursor
    }

}
