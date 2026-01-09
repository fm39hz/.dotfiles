import "../Components"
import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Services

BentoCard {
    id: root

    required property var colors

    function execute(cmd) {
        Quickshell.execDetached(["sh", "-c", cmd]);
    }

    cardColor: colors.surface
    borderColor: colors.border

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 14
        spacing: 4

        Text {
            text: Qt.formatDateTime(new Date(), "dddd")
            color: root.colors.fg
            font.pixelSize: 18
            font.bold: true
            Layout.alignment: Qt.AlignHCenter
        }

        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true

            Text {
                anchors.centerIn: parent
                text: WeatherService.icon // Fetch icon from service
                font.family: "Symbols Nerd Font"
                font.pixelSize: 42
                color: root.colors.accent
            }

        }

        Text {
            text: WeatherService.conditionText
            color: root.colors.fg
            font.pixelSize: 14
            font.bold: true
            Layout.alignment: Qt.AlignHCenter
        }

        Text {
            text: WeatherService.temperature + " in " + WeatherService.city
            color: root.colors.muted
            font.pixelSize: 12
            Layout.alignment: Qt.AlignHCenter
        }

        Item {
            Layout.preferredHeight: 12
        }

    }

}
