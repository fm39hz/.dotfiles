import "root:/widgets"
import "root:/services"
import "root:/utils"
import "root:/config"
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import QtQuick

Item {
    id: root

    property string workspaceName: ""
    readonly property var workspaceClients: workspaceName !== ""
        ? Hyprland.clients.filter(c => c.workspace?.name === workspaceName)
        : []

    readonly property string displayName: workspaceName.startsWith("special:")
        ? workspaceName.slice(8)
        : workspaceName

    implicitWidth: workspaceClients.length > 0 ? child.implicitWidth : -Appearance.padding.large * 2
    implicitHeight: child.implicitHeight

    Column {
        id: child

        anchors.centerIn: parent
        spacing: Appearance.spacing.normal

        StyledText {
            text: `Special: ${root.displayName} (${root.workspaceClients.length} window${root.workspaceClients.length === 1 ? "" : "s"})`
            font.pointSize: Appearance.font.size.small
            color: Colours.palette.m3onSurfaceVariant
            horizontalAlignment: Text.AlignHCenter
            width: parent.width
        }

        Repeater {
            model: ScriptModel {
                values: root.workspaceClients
            }

            Row {
                required property var modelData
                spacing: Appearance.spacing.normal

                IconImage {
                    id: icon
                    implicitSize: 24
                    source: Icons.getAppIcon(parent.modelData?.wmClass ?? "", "image-missing")
                    anchors.verticalCenter: parent.verticalCenter
                }

                Column {
                    spacing: 2

                    StyledText {
                        text: parent.parent.modelData?.title ?? ""
                        font.pointSize: Appearance.font.size.normal
                        elide: Text.ElideRight
                        width: Math.min(implicitWidth, 400)
                    }

                    StyledText {
                        text: parent.parent.modelData?.wmClass ?? ""
                        color: Colours.palette.m3onSurfaceVariant
                        font.pointSize: Appearance.font.size.smaller
                        elide: Text.ElideRight
                        width: Math.min(implicitWidth, 400)
                    }
                }
            }
        }
    }

    component Anim: NumberAnimation {
        duration: Appearance.anim.durations.normal
        easing.type: Easing.BezierSpline
        easing.bezierCurve: Appearance.anim.curves.emphasized
    }
}
