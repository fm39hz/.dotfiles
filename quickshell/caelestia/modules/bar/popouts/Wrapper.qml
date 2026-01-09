import "root:/services"
import "root:/config"
import Quickshell
import QtQuick

Item {
    id: root

    required property ShellScreen screen

    property alias currentName: content.currentName
    property alias currentCenter: content.currentCenter
    property alias hasCurrent: content.hasCurrent
    property alias currentWorkspace: content.currentWorkspace
    property alias currentSpecialWorkspace: content.currentSpecialWorkspace

    readonly property bool fusedLeft: x <= 0
    readonly property bool fusedRight: x + width >= parent.width

    visible: width > 0 && height > 0

    implicitWidth: content.implicitWidth
    implicitHeight: content.implicitHeight

    Content {
        id: content

        screen: root.screen
    }
}
