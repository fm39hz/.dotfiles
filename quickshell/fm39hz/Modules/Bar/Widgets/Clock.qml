import QtQuick
import QtQuick.Layouts
import qs.Core

Rectangle {
    required property var colors
    required property string fontFamily
    required property int fontSize
    required property string time
    required property var globalState

    anchors.centerIn: parent
    height: 26
    width: clockText.implicitWidth + 24
    radius: height / 2
    color: colors.accent

    Text {
        id: clockText

        anchors.centerIn: parent
        text: time
        color: colors.bg
        font.pixelSize: fontSize - 1
        font.family: fontFamily
        font.bold: true
    }

    MouseArea {
        anchors.fill: parent
        onClicked: globalState.toggleSettings()
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true
    }

}
