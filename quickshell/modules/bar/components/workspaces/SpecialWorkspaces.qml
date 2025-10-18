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

    visible: hasSpecialWorkspaces

    RowLayout {
        id: layout

        spacing: Appearance.spacing.small

        Repeater {
            model: root.specialWorkspaces

            Item {
                id: specialWorkspaceItem

                required property var modelData
                readonly property bool isSpecialWorkspace: true // Flag for finding special workspace children

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
            const pos = mapToItem(layout, event.x, event.y);
            const child = layout.childAt(pos.x, pos.y);
            if (child && child.isSpecialWorkspace) {
                Hyprland.dispatch(`togglespecialworkspace ${child.modelData.shortName}`);
            }
        }

        onEntered: event => {
            const pos = mapToItem(layout, event.x, event.y);
            if (!pos) {
                // Fallback to direct coordinates if mapping fails
                const child = layout.childAt(event.x, event.y);
                if (child && child.isSpecialWorkspace) {
                    root.hoveredSpecialWorkspace = child.modelData.name;
                } else {
                    root.hoveredSpecialWorkspace = "";
                }
                return;
            }
            const child = layout.childAt(pos.x, pos.y);
            if (child && child.isSpecialWorkspace) {
                root.hoveredSpecialWorkspace = child.modelData.name;
            } else {
                root.hoveredSpecialWorkspace = "";
            }
        }

        onPositionChanged: event => {
            const pos = mapToItem(layout, event.x, event.y);
            if (!pos) {
                // Fallback to direct coordinates if mapping fails
                const child = layout.childAt(event.x, event.y);
                if (child && child.isSpecialWorkspace) {
                    root.hoveredSpecialWorkspace = child.modelData.name;
                } else {
                    root.hoveredSpecialWorkspace = "";
                }
                return;
            }
            const child = layout.childAt(pos.x, pos.y);
            if (child && child.isSpecialWorkspace) {
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
