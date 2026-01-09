import QtQuick
import QtQuick.Layouts

Rectangle {
    required property var colors

    Layout.preferredWidth: 1
    Layout.preferredHeight: 14
    Layout.alignment: Qt.AlignVCenter
    color: colors.muted
    opacity: 0.5
}
