pragma ComponentBehavior: Bound

import "root:/widgets"
import "root:/services"
import "root:/config"
import QtQuick
import QtQuick.Layouts

Item {
    id: root

    // Property to track which special workspace is being hovered
    property string hoveredSpecialWorkspace: ""
    readonly property bool showSpecialWorkspacePreview: hoveredSpecialWorkspace !== ""

    // Get all active special workspaces
    readonly property var specialWorkspaces: {
        const specials = [];
        for (const ws of Hyprland.workspaces.values) {
            if (ws.name.startsWith("special:")) {
                specials.push({
                    name: ws.name,
                    shortName: ws.name.slice(8), // Remove "special:" prefix
                    id: ws.id,
                    windows: ws.lastIpcObject.windows
                });
            }
        }
        return specials;
    }

    readonly property bool hasSpecialWorkspaces: specialWorkspaces.length > 0

    implicitWidth: hasSpecialWorkspaces ? layout.implicitWidth : 0
    implicitHeight: layout.implicitHeight
    width: implicitWidth
    height: implicitHeight

    visible: hasSpecialWorkspaces

    RowLayout {
        id: layout

        anchors.fill: parent
        spacing: Appearance.spacing.small
        visible: root.hasSpecialWorkspaces

        Repeater {
            model: root.specialWorkspaces

            Item {
                id: specialWorkspaceItem

                required property var modelData

                Layout.preferredWidth: specialText.implicitWidth + Appearance.padding.small * 2
                Layout.preferredHeight: Config.bar.sizes.innerHeight
                Layout.alignment: Qt.AlignVCenter

                readonly property bool isActive: Hyprland.activeClient?.workspace?.name === modelData.name

                StyledRect {
                    anchors.fill: parent
                    radius: Appearance.rounding.normal
                    color: parent.isActive
                        ? Colours.palette.m3primaryContainer
                        : Colours.palette.m3surfaceContainerHighest

                    Behavior on color {
                        ColorAnimation {
                            duration: Appearance.anim.durations.small
                            easing.type: Easing.BezierSpline
                            easing.bezierCurve: Appearance.anim.curves.standard
                        }
                    }
                }

                StyledText {
                    id: specialText
                    anchors.centerIn: parent
                    text: `󰮯 ${parent.modelData.shortName}`
                    font.pointSize: Appearance.font.size.small
                    color: parent.isActive
                        ? Colours.palette.m3onPrimaryContainer
                        : Colours.palette.m3onSurface

                    Behavior on color {
                        ColorAnimation {
                            duration: Appearance.anim.durations.small
                            easing.type: Easing.BezierSpline
                            easing.bezierCurve: Appearance.anim.curves.standard
                        }
                    }
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onPressed: event => {
            const child = layout.childAt(event.x, event.y);
            if (child && child.modelData) {
                // Toggle the special workspace
                Hyprland.dispatch(`togglespecialworkspace ${child.modelData.shortName}`);
            }
        }

        onEntered: event => {
            const child = layout.childAt(event.x, event.y);
            if (child && child.modelData) {
                root.hoveredSpecialWorkspace = child.modelData.name;
            }
        }

        onPositionChanged: event => {
            const child = layout.childAt(event.x, event.y);
            if (child && child.modelData) {
                root.hoveredSpecialWorkspace = child.modelData.name;
            } else {
                root.hoveredSpecialWorkspace = "";
            }
        }

        onExited: {
            root.hoveredSpecialWorkspace = "";
        }
    }
}
