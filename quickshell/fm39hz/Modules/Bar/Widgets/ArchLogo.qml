import QtQuick
import QtQuick.Layouts

Rectangle {
    Layout.preferredWidth: 26
    Layout.preferredHeight: 26
    radius: height / 2
    color: "transparent"

    Image {
        anchors.centerIn: parent
        width: 18
        height: 18
        source: "../../../Assets/arch.svg"
        fillMode: Image.PreserveAspectFit
        opacity: 0.9
    }

}
