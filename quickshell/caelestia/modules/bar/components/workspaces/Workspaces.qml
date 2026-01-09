pragma ComponentBehavior: Bound

import "root:/widgets"
import "root:/services"
import "root:/config"
import QtQuick
import QtQuick.Layouts

Item {
    id: root

    readonly property list<Workspace> workspaces: layout.children.filter(c => c.isWorkspace).sort((w1, w2) => w1.ws - w2.ws)
    readonly property var occupied: Hyprland.workspaces.values.reduce((acc, curr) => {
        acc[curr.id] = curr.lastIpcObject.windows > 0;
        return acc;
    }, {})
    readonly property int groupOffset: Math.floor((Hyprland.activeWsId - 1) / Config.bar.workspaces.shown) * Config.bar.workspaces.shown

    property int hoveredWorkspace: -1
    readonly property bool showWorkspacePreview: hoveredWorkspace !== -1

    implicitWidth: layout.implicitWidth
    implicitHeight: layout.implicitHeight

    RowLayout {
        id: layout

        spacing: 0
        layer.enabled: true
        layer.smooth: true

        Repeater {
            model: Config.bar.workspaces.shown

            Workspace {
                occupied: root.occupied
                groupOffset: root.groupOffset
            }
        }
    }

    Loader {
        active: Config.bar.workspaces.occupiedBg
        asynchronous: true

        z: -1
        anchors.fill: parent

        sourceComponent: OccupiedBg {
            workspaces: root.workspaces
            occupied: root.occupied
            groupOffset: root.groupOffset
        }
    }

    Loader {
        active: Config.bar.workspaces.activeIndicator
        asynchronous: true

        sourceComponent: ActiveIndicator {
            workspaces: root.workspaces
            mask: layout
            maskWidth: root.width
            maskHeight: root.height
            groupOffset: root.groupOffset
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onPressed: event => {
            const pos = mapToItem(layout, event.x, event.y);
            const child = layout.childAt(pos.x, pos.y);
            if (child && child.isWorkspace) {
                const ws = child.index + root.groupOffset + 1;
                if (Hyprland.activeWsId !== ws)
                    Hyprland.dispatch(`workspace ${ws}`);
            }
        }

        onEntered: event => {
            const pos = mapToItem(layout, event.x, event.y);
            if (!pos) {
                console.log("Workspaces onEntered: mapToItem returned null, using direct coords");
                // Fallback to direct coordinates if mapping fails
                const child = layout.childAt(event.x, event.y);
                if (child && child.isWorkspace) {
                    root.hoveredWorkspace = child.index + root.groupOffset + 1;
                } else {
                    root.hoveredWorkspace = -1;
                }
                return;
            }
            console.log("Workspaces onEntered: event.x=" + event.x + " event.y=" + event.y + " mapped.x=" + pos.x + " mapped.y=" + pos.y);
            const child = layout.childAt(pos.x, pos.y);
            console.log("Workspaces onEntered: child=" + child + " isWorkspace=" + (child ? child.isWorkspace : "null"));
            if (child && child.isWorkspace) {
                console.log("Workspaces onEntered: Setting hoveredWorkspace to " + (child.index + root.groupOffset + 1));
                root.hoveredWorkspace = child.index + root.groupOffset + 1;
            } else {
                console.log("Workspaces onEntered: Resetting hoveredWorkspace to -1");
                root.hoveredWorkspace = -1;
            }
        }

        onPositionChanged: event => {
            const pos = mapToItem(layout, event.x, event.y);
            if (!pos) {
                // Fallback to direct coordinates if mapping fails
                const child = layout.childAt(event.x, event.y);
                if (child && child.isWorkspace) {
                    root.hoveredWorkspace = child.index + root.groupOffset + 1;
                } else {
                    root.hoveredWorkspace = -1;
                }
                return;
            }
            const child = layout.childAt(pos.x, pos.y);
            if (child && child.isWorkspace) {
                root.hoveredWorkspace = child.index + root.groupOffset + 1;
            } else {
                root.hoveredWorkspace = -1;
            }
        }

        onExited: {
            root.hoveredWorkspace = -1;
        }
    }
}
