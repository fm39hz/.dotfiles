import "root:/widgets"
import "root:/services"
import "root:/config"
import "root:/modules/bar/popouts" as BarPopouts
import "components"
import "components/workspaces"
import Quickshell
import QtQuick
import QtQuick.Layouts

Item {
    id: root

    required property ShellScreen screen
    required property BarPopouts.Wrapper popouts

    // Monitor workspace hover changes
    Connections {
        target: workspacesInner

        function onHoveredWorkspaceChanged() {
            if (workspacesInner.hoveredWorkspace === -1) {
                // Hide popout when leaving workspace area
                popouts.hasCurrent = false;
            } else {
                // Show/update popout when hovering over a workspace
                updateWorkspacePopout();
            }
        }
    }

    function updateWorkspacePopout() {
        popouts.currentName = "workspace";
        popouts.currentWorkspace = workspacesInner.hoveredWorkspace;
        const aw = activeWindow.child;
        popouts.currentCenter = Qt.binding(() => {
            const awPos = activeWindow.mapToItem(child, 0, 0);
            return awPos.x + aw.x + aw.implicitWidth / 2;
        });
        popouts.hasCurrent = true;
    }

    function isWorkspacePreviewActive(): bool {
        return workspacesInner.showWorkspacePreview && workspacesInner.hoveredWorkspace !== -1;
    }

    function checkPopout(x: real): void {
        const spacing = Appearance.spacing.small;

        // Use mapToItem to get proper coordinates relative to the bar
        const trayPos = tray.mapToItem(child, 0, 0);
        const tx = trayPos.x;
        const tw = tray.implicitWidth;
        const trayItems = tray.items;

        const statusPos = statusIcons.mapToItem(child, 0, 0);
        const n = statusIconsInner.network;
        const nx = statusPos.x + statusIconsInner.x + n.x - spacing / 2;

        const bls = statusPos.x + statusIconsInner.x + statusIconsInner.bs - spacing / 2;
        const ble = statusPos.x + statusIconsInner.x + statusIconsInner.be + spacing / 2;

        const b = statusIconsInner.battery;
        const bx = statusPos.x + statusIconsInner.x + b.x - spacing / 2;

        // Check workspace hover preview
        if (workspacesInner.showWorkspacePreview && workspacesInner.hoveredWorkspace !== -1) {
            popouts.currentName = "workspace";
            popouts.currentWorkspace = workspacesInner.hoveredWorkspace;
            const aw = activeWindow.child;
            popouts.currentCenter = Qt.binding(() => {
                const awPos = activeWindow.mapToItem(child, 0, 0);
                return awPos.x + aw.x + aw.implicitWidth / 2;
            });
            popouts.hasCurrent = true;
        } else if (x >= tx && x <= tx + tw) {
            const index = Math.floor(((x - tx) / tw) * trayItems.count);
            const item = trayItems.itemAt(index);

            popouts.currentName = `traymenu${index}`;
            popouts.currentCenter = Qt.binding(() => {
                const pos = tray.mapToItem(child, 0, 0);
                return pos.x + item.x + item.implicitWidth / 2;
            });
            popouts.hasCurrent = true;
        } else if (x >= nx && x <= nx + n.implicitWidth + spacing) {
            popouts.currentName = "network";
            popouts.currentCenter = Qt.binding(() => {
                const pos = statusIcons.mapToItem(child, 0, 0);
                return pos.x + statusIconsInner.x + n.x + n.implicitWidth / 2;
            });
            popouts.hasCurrent = true;
        } else if (x >= bls && x <= ble) {
            popouts.currentName = "bluetooth";
            popouts.currentCenter = Qt.binding(() => {
                const pos = statusIcons.mapToItem(child, 0, 0);
                return pos.x + statusIconsInner.x + statusIconsInner.bs + (statusIconsInner.be - statusIconsInner.bs) / 2;
            });
            popouts.hasCurrent = true;
        } else if (x >= bx && x <= bx + b.implicitWidth + spacing) {
            popouts.currentName = "battery";
            popouts.currentCenter = Qt.binding(() => {
                const pos = statusIcons.mapToItem(child, 0, 0);
                return pos.x + statusIconsInner.x + b.x + b.implicitWidth / 2;
            });
            popouts.hasCurrent = true;
        } else {
            popouts.hasCurrent = false;
        }
    }

    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top

    implicitHeight: child.implicitHeight + Config.border.thickness * 2

    Item {
        id: child

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter

        implicitHeight: Math.max(osIcon.implicitHeight, workspaces.implicitHeight, activeWindow.implicitHeight, tray.implicitHeight, clock.implicitHeight, )

        GridLayout {
            id: gridLayout
            
            anchors.fill: parent
            anchors.leftMargin: 18
            anchors.rightMargin: 18
            anchors.bottomMargin: 8
            columns: 3
            columnSpacing: 12

            // Calculate exact widths to ensure perfect centering
            readonly property real totalWidth: width
            readonly property real centerWidth: 240
            readonly property real remainingWidth: totalWidth - centerWidth - (columnSpacing * 2)
            readonly property real sideWidth: remainingWidth / 2

            // LEFT SECTION: OS Icon + Workspaces + Window Title
            RowLayout {
                Layout.column: 0
                Layout.alignment: Qt.AlignHLeft
                Layout.preferredWidth: gridLayout.sideWidth
                Layout.maximumWidth: gridLayout.sideWidth
                
                // FLEX-START: Items start from left edge (default behavior)

                // OS Icon / Launcher - starts from left edge
                OsIcon {
                    id: osIcon
                    
                    StateLayer {
                        anchors.fill: undefined
                        anchors.centerIn: parent
                        implicitWidth: parent.implicitHeight + Appearance.padding.small * 2
                        implicitHeight: implicitWidth
                        radius: Appearance.rounding.full

                        function onClicked(): void {
                            const v = Visibilities.screens[QsWindow.window.screen];
                            v.launcher = !v.launcher;
                        }
                    }
                }

                // Workspace Icons
                StyledRect {
                    id: workspaces

                    Layout.fillWidth: true
                    Layout.maximumWidth: 300
                    Layout.preferredHeight: implicitHeight

                    radius: Appearance.rounding.full
                    color: Colours.palette.m3surfaceContainer

                    MouseArea {
                        anchors.fill: parent
                        anchors.topMargin: -Config.border.thickness
                        anchors.bottomMargin: -Config.border.thickness

                        onWheel: event => {
                            const activeWs = Hyprland.activeClient?.workspace?.name;
                            if (activeWs?.startsWith("special:"))
                                Hyprland.dispatch(`togglespecialworkspace ${activeWs.slice(8)}`);
                            else if (event.angleDelta.y < 0 || Hyprland.activeWsId > 1)
                                Hyprland.dispatch(`workspace r${event.angleDelta.y > 0 ? "-" : "+"}1`);
                        }
                    }

                    Workspaces {
                        id: workspacesInner
                        anchors.centerIn: parent
                    }
                }

                // Window Title
                ActiveWindow {
                    id: activeWindow

                    Layout.fillWidth: true
                    Layout.maximumWidth: 300
                    
                    monitor: Brightness.getMonitorForScreen(root.screen)
                }
                Item {
                    Layout.fillWidth: true  // Takes all available space
                }
            }

            // CENTER SECTION: Clock (Fixed position, never moves)
            Item {
                Layout.column: 1
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.preferredWidth: gridLayout.centerWidth
                Layout.maximumWidth: gridLayout.centerWidth
                Layout.fillHeight: true


                Clock {
                    id: clock
                    
                    anchors.centerIn: parent
                    
                    StateLayer {
                        anchors.fill: undefined
                        anchors.centerIn: parent
                        implicitWidth: 100
                        implicitHeight: parent.parent.implicitHeight
                        radius: Appearance.rounding.normal

                        function onClicked(): void {
                            const v = Visibilities.screens[QsWindow.window.screen];
                            v.dashboard = !v.dashboard;
                        }
                    }
                }
            }

            // RIGHT SECTION: Tray + System Status + Power
            RowLayout {
                Layout.column: 2
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                Layout.preferredWidth: gridLayout.sideWidth
                Layout.maximumWidth: gridLayout.sideWidth
                spacing: 8
                
                // FLEX-END: Add spacer to push items to the right edge
                Item {
                    Layout.fillWidth: true  // Takes all available space
                }


                // System Tray - pushed to right
                Item {
                    id: trayContainer
                    Layout.preferredWidth: tray.implicitWidth
                    Layout.preferredHeight: child.implicitHeight
                    
                    Tray {
                        id: tray
                        anchors.centerIn: parent
                    }
                }

                // Item {
                //     Layout.fillWidth: true  // Takes all available space
                // }
                // System Status Icons
                StyledRect {
                    id: statusIcons
                    Layout.preferredWidth: tray.implicitWidth
                    Layout.preferredHeight: child.implicitHeight

                    radius: Appearance.rounding.full
                    color: Colours.palette.m3surfaceContainer

                    // implicitWidth: statusIconsInner.implicitWidth + Appearance.padding.normal * 2

                    StatusIcons {
                        id: statusIconsInner
                        anchors.centerIn: parent
                    }
                }

                // Power Menu - ends at right edge
                Power {
                    id: power
                }
            }
        }
    }
}
