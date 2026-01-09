import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.Core

Rectangle {
    property int notifId: 0
    property string summary: ""
    property string body: ""
    property string image: ""
    property string appIcon: ""
    property string appName: ""
    property string time: ""
    property var actions: null
    property var theme
    property bool expanded: false

    signal removeRequested()
    signal clicked()
    signal actionClicked(string actionId)

    width: ListView.view ? ListView.view.width : 400
    implicitHeight: Math.max(80, mainLayout.implicitHeight + 32)
    height: implicitHeight
    color: theme ? theme.surface : "#252932"
    radius: 12

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: (mouse) => {
            console.log("NotificationItem Clicked! Button:", mouse.button, "Right:", Qt.RightButton, "Left:", Qt.LeftButton)
            if (mouse.button === Qt.RightButton) {
                console.log("Right click detected. Toggling expansion. Current:", parent.expanded)
                parent.expanded = !parent.expanded;
                console.log("New expansion:", parent.expanded)
            } else {
                console.log("Left click detected. Activ ating.")
                parent.clicked();
            }
        }
    }

    ColumnLayout {
        id: mainLayout
        anchors.fill: parent
        anchors.margins: 12
        spacing: 8

        // Header Row: Icon, App Name, Time, Close
        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            // App Icon
            Rectangle {
                Layout.preferredWidth: 20
                Layout.preferredHeight: 20
                color: "transparent" // theme.tileActive
                radius: 6

                Image {
                    anchors.centerIn: parent
                    width: 16
                    height: 16
                    fillMode: Image.PreserveAspectFit
                    source: {
                        var icon = appIcon || "";
                        if (icon !== "") {
                            if (icon.startsWith("/") || icon.startsWith("file://"))
                                return icon.startsWith("file://") ? icon : "file://" + icon;
                            return "image://icon/" + icon;
                        }
                        return "";
                    }
                    visible: status === Image.Ready
                    cache: false
                }
                
                Text {
                    anchors.centerIn: parent
                    text: "󰂚"
                    font.pixelSize: 14
                    font.family: "Symbols Nerd Font"
                    color: theme ? theme.iconMuted : "#70727C"
                    visible: !parent.children[0].visible
                }
            }

            // App Name
            Text {
                text: appName || "System"
                color: theme ? theme.subtext : "#9BA3B8"
                font.pixelSize: 11
                font.bold: true
                Layout.fillWidth: true
                elide: Text.ElideRight
            }

            // Time
            Text {
                text: time
                color: theme ? theme.muted : "#5C606C"
                font.pixelSize: 10
            }

            // Chevron (Expand Indicator)
            Text {
                text: "󰁸" // Chevron down
                color: theme ? theme.muted : "#5C606C"
                font.pixelSize: 10
                font.family: "Symbols Nerd Font"
                rotation: expanded ? 180 : 0
                visible: actions && actions.length > 0
                
                Behavior on rotation { NumberAnimation { duration: 200 } }
            }

            // Close Button
            Rectangle {
                Layout.preferredWidth: 20
                Layout.preferredHeight: 20
                color: closeArea.containsMouse ? (theme ? theme.urgent : "#FF5252") : "transparent"
                radius: 10
                
                Text {
                    anchors.centerIn: parent
                    text: "󰅖"
                    font.pixelSize: 12
                    font.family: "Symbols Nerd Font"
                    color: closeArea.containsMouse ? (theme ? theme.bg : "#FFFFFF") : (theme ? theme.iconMuted : "#9BA3B8")
                }

                MouseArea {
                    id: closeArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: removeRequested()
                }
                
                Behavior on color { ColorAnimation { duration: 150 } }
            }
        }

        // Content Row
        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            // Large Image (if available, otherwise hidden) - Optional logic could be added here to show image if different from icon
            
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2

                Text {
                    text: summary
                    color: theme ? theme.text : "#E8EAF0"
                    font.pixelSize: 13
                    font.weight: Font.DemiBold
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                    maximumLineCount: 1
                }

                Text {
                    text: body
                    color: theme ? theme.subtext : "#9BA3B8"
                    font.pixelSize: 12
                    elide: Text.ElideRight
                    wrapMode: Text.Wrap
                    maximumLineCount: 3
                    Layout.fillWidth: true
                    visible: text !== ""
                }

                // Actions Flow
                Flow {
                    Layout.fillWidth: true
                    spacing: 8
                    visible: expanded && actions && actions.length > 0
                    opacity: visible ? 1 : 0
                    
                    Behavior on opacity { NumberAnimation { duration: 200 } }
                    
                    Repeater {
                        model: actions
                        
                        Rectangle {
                           required property var modelData
                           
                           width: actionLabel.implicitWidth + 24
                           height: 28
                           radius: 6
                           color: actionMouse.containsMouse ? (theme ? theme.accent : "#70727C") : (theme ? theme.surface : "#3C4048")
                           border.width: 1
                           border.color: theme ? theme.border : "#4C4F5A"

                           Text {
                               id: actionLabel
                               anchors.centerIn: parent
                               text: modelData.label
                               color: actionMouse.containsMouse ? (theme ? theme.bg : "#FFFFFF") : (theme ? theme.text : "#E8EAF0")
                               font.pixelSize: 11
                               font.bold: true
                           }

                           MouseArea {
                               id: actionMouse
                               anchors.fill: parent
                               cursorShape: Qt.PointingHandCursor
                               hoverEnabled: true
                               onClicked: {
                                   // Consume click so item doesn't activate
                                   parent.parent.parent.parent.parent.actionClicked(modelData.id)
                               }
                           }
                           
                           Behavior on color { ColorAnimation { duration: 150 } }
                        }
                    }
                }
            }
        }
    }

}
