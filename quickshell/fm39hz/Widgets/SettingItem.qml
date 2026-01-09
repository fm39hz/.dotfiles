import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    default property alias content: container.data
    property string label: ""
    property string sublabel: ""
    property string icon: ""
    property var colors: null

    implicitHeight: Math.max(64, container.implicitHeight + 24)
    Layout.fillWidth: true
    radius: 12
    color: colors ? colors.surface : "#1e1e2e"

    GridLayout {
        anchors.fill: parent
        anchors.margins: 16
        rowSpacing: 8
        columnSpacing: 16
        columns: root.width > 400 ? 3 : 2

        Rectangle {
            visible: root.icon !== ""
            Layout.preferredWidth: 40
            Layout.preferredHeight: 40
            radius: 10
            color: Qt.rgba(root.colors ? root.colors.accent.r : 0.5, root.colors ? root.colors.accent.g : 0.5, root.colors ? root.colors.accent.b : 0.5, 0.1)

            Text {
                anchors.centerIn: parent
                text: root.icon
                font.family: "Symbols Nerd Font"
                font.pixelSize: 20
                color: root.colors ? root.colors.accent : "#cba6f7"
            }

        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2

            Text {
                text: root.label
                font.pixelSize: 14
                font.weight: Font.Medium
                color: root.colors ? root.colors.fg : "#cdd6f4"
                Layout.fillWidth: true
                elide: Text.ElideRight
            }

            Text {
                text: root.sublabel
                font.pixelSize: 12
                color: root.colors ? Qt.rgba(root.colors.fg.r, root.colors.fg.g, root.colors.fg.b, 0.5) : "#a6adc8"
                visible: root.sublabel !== ""
                Layout.fillWidth: true
                elide: Text.ElideRight
                wrapMode: Text.WordWrap
            }

        }

        RowLayout {
            id: container

            Layout.columnSpan: root.width > 400 ? 1 : 2
            Layout.alignment: root.width > 400 ? (Qt.AlignRight | Qt.AlignVCenter) : (Qt.AlignLeft | Qt.AlignVCenter)
            Layout.fillWidth: root.width <= 400
            spacing: 10
        }

    }

}
