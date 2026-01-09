import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes
import qs.Core

Item {
    id: root

    required property var theme
    property real cpuUsage: 0
    property real memUsage: 0
    property real memUsed: 0
    property real memTotal: 0
    property real diskUsage: 0
    property real diskFree: 0

    function alpha(col, val) {
        if (!col)
            return "transparent";

        return Qt.rgba(col.r, col.g, col.b, val);
    }

    function formatBytes(bytes) {
        if (bytes > 1.09951e+12)
            return (bytes / 1.09951e+12).toFixed(1) + " TB";

        if (bytes > 1.07374e+09)
            return (bytes / 1.07374e+09).toFixed(1) + " GB";

        if (bytes > 1.04858e+06)
            return (bytes / 1.04858e+06).toFixed(0) + " MB";

        return bytes + " B";
    }

    implicitWidth: 440
    implicitHeight: 360

    Rectangle {
        anchors.fill: parent
        radius: 32
        color: root.alpha(theme.bg, 0.4)
        border.width: 1
        border.color: root.alpha(theme.fg, 0.08)

        Rectangle {
            anchors.fill: parent
            anchors.margins: 1
            radius: 31
            color: "transparent"
            border.width: 1
            border.color: Qt.rgba(0, 0, 0, 0.2)
            z: 1
        }

    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 20

        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            Rectangle {
                width: 4
                height: 16
                color: theme.accent
                radius: 2
            }

            Text {
                text: "SYSTEM TELEMETRY"
                font.bold: true
                font.pixelSize: 12
                font.letterSpacing: 2
                color: root.alpha(theme.fg, 0.6)
            }

            Item {
                Layout.fillWidth: true
            }

        }

        GridLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            columns: 2
            rowSpacing: 20
            columnSpacing: 20

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredHeight: 180

                Rectangle {
                    anchors.fill: parent
                    radius: 24
                    color: root.alpha(theme.fg, 0.03)
                    border.width: 1
                    border.color: root.alpha(theme.fg, 0.05)
                }

                Item {
                    anchors.centerIn: parent
                    width: 140
                    height: 140

                    Repeater {
                        model: 30 // Ticks count

                        Item {
                            anchors.fill: parent
                            rotation: -135 + (index * (270 / 29)) // 270 degree arc

                            Rectangle {
                                anchors.top: parent.top
                                anchors.horizontalCenter: parent.horizontalCenter
                                width: index % 5 === 0 ? 2 : 1
                                height: index % 5 === 0 ? 10 : 6
                                color: index % 5 === 0 ? root.alpha(theme.fg, 0.5) : root.alpha(theme.fg, 0.2)
                                radius: 1
                            }

                        }

                    }

                    Shape {
                        anchors.fill: parent
                        layer.enabled: true
                        layer.samples: 4

                        ShapePath {
                            strokeColor: "transparent"
                            fillColor: "transparent"
                        }

                        ShapePath {
                            strokeColor: theme.urgent
                            strokeWidth: 6
                            fillColor: "transparent"
                            capStyle: ShapePath.RoundCap

                            PathAngleArc {
                                centerX: 70
                                centerY: 70
                                radiusX: 58
                                radiusY: 58
                                startAngle: -135
                                sweepAngle: 270 * (root.cpuUsage / 100)

                                Behavior on sweepAngle {
                                    NumberAnimation {
                                        duration: 400
                                        easing.type: Easing.OutQuad
                                    }

                                }

                            }

                        }

                    }

                    Shape {
                        anchors.fill: parent
                        opacity: 0.3
                        layer.enabled: true
                        layer.samples: 4

                        ShapePath {
                            strokeColor: theme.urgent
                            strokeWidth: 12 // Thicker for glow
                            fillColor: "transparent"
                            capStyle: ShapePath.RoundCap

                            PathAngleArc {
                                centerX: 70
                                centerY: 70
                                radiusX: 58
                                radiusY: 58
                                startAngle: -135
                                sweepAngle: 270 * (root.cpuUsage / 100)

                                Behavior on sweepAngle {
                                    NumberAnimation {
                                        duration: 400
                                        easing.type: Easing.OutQuad
                                    }

                                }

                            }

                        }

                    }

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 2

                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: "CPU"
                            font.pixelSize: 11
                            font.letterSpacing: 1
                            color: root.alpha(theme.fg, 0.5)
                            font.bold: true
                        }

                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: Math.round(root.cpuUsage)
                            font.pixelSize: 32
                            font.bold: true
                            color: theme.fg

                            Text {
                                anchors.left: parent.right
                                anchors.baseline: parent.baseline
                                anchors.leftMargin: 2
                                text: "%"
                                font.pixelSize: 14
                                color: root.alpha(theme.fg, 0.5)
                            }

                        }

                    }

                }

            }

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredHeight: 180

                Rectangle {
                    anchors.fill: parent
                    radius: 24
                    color: root.alpha(theme.fg, 0.03)
                    border.width: 1
                    border.color: root.alpha(theme.fg, 0.05)
                }

                Item {
                    anchors.centerIn: parent
                    width: 140
                    height: 140

                    Repeater {
                        model: 30

                        Item {
                            anchors.fill: parent
                            rotation: -135 + (index * (270 / 29))

                            Rectangle {
                                anchors.top: parent.top
                                anchors.horizontalCenter: parent.horizontalCenter
                                width: index % 5 === 0 ? 2 : 1
                                height: index % 5 === 0 ? 10 : 6
                                color: index % 5 === 0 ? root.alpha(theme.fg, 0.5) : root.alpha(theme.fg, 0.2)
                                radius: 1
                            }

                        }

                    }

                    Shape {
                        anchors.fill: parent
                        layer.enabled: true
                        layer.samples: 4

                        ShapePath {
                            strokeColor: theme.accent
                            strokeWidth: 6
                            fillColor: "transparent"
                            capStyle: ShapePath.RoundCap

                            PathAngleArc {
                                centerX: 70
                                centerY: 70
                                radiusX: 58
                                radiusY: 58
                                startAngle: -135
                                sweepAngle: 270 * (root.memUsage / 100)

                                Behavior on sweepAngle {
                                    NumberAnimation {
                                        duration: 400
                                        easing.type: Easing.OutQuad
                                    }

                                }

                            }

                        }

                    }

                    Shape {
                        anchors.fill: parent
                        opacity: 0.3
                        layer.enabled: true
                        layer.samples: 4

                        ShapePath {
                            strokeColor: theme.accent
                            strokeWidth: 12
                            fillColor: "transparent"
                            capStyle: ShapePath.RoundCap

                            PathAngleArc {
                                centerX: 70
                                centerY: 70
                                radiusX: 58
                                radiusY: 58
                                startAngle: -135
                                sweepAngle: 270 * (root.memUsage / 100)

                                Behavior on sweepAngle {
                                    NumberAnimation {
                                        duration: 400
                                        easing.type: Easing.OutQuad
                                    }

                                }

                            }

                        }

                    }

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 2

                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: "RAM"
                            font.pixelSize: 11
                            font.letterSpacing: 1
                            color: root.alpha(theme.fg, 0.5)
                            font.bold: true
                        }

                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: Math.round(root.memUsage)
                            font.pixelSize: 32
                            font.bold: true
                            color: theme.fg

                            Text {
                                anchors.left: parent.right
                                anchors.baseline: parent.baseline
                                anchors.leftMargin: 2
                                text: "%"
                                font.pixelSize: 14
                                color: root.alpha(theme.fg, 0.5)
                            }

                        }

                    }

                    Text {
                        anchors.bottom: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottomMargin: 20
                        text: root.formatBytes(root.memUsed)
                        font.pixelSize: 10
                        color: root.alpha(theme.fg, 0.4)
                    }

                }

            }

            Item {
                Layout.columnSpan: 2
                Layout.fillWidth: true
                Layout.preferredHeight: 80

                Rectangle {
                    anchors.fill: parent
                    radius: 20
                    color: root.alpha(theme.fg, 0.03)
                    border.width: 1
                    border.color: root.alpha(theme.fg, 0.05)
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 20

                    Rectangle {
                        width: 44
                        height: 44
                        radius: 12
                        color: root.alpha(theme.green, 0.1)
                        border.width: 1
                        border.color: root.alpha(theme.green, 0.2)

                        Text {
                            anchors.centerIn: parent
                            text: "󰋊"
                            font.family: "Symbols Nerd Font"
                            font.pixelSize: 20
                            color: theme.green
                        }

                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 6

                        RowLayout {
                            Layout.fillWidth: true

                            Text {
                                text: "PRIMARY DRIVE"
                                font.bold: true
                                font.pixelSize: 11
                                font.letterSpacing: 1
                                color: root.alpha(theme.fg, 0.7)
                            }

                            Item {
                                Layout.fillWidth: true
                            }

                            Text {
                                text: root.formatBytes(root.diskFree) + " FREE"
                                font.bold: true
                                font.pixelSize: 11
                                font.letterSpacing: 1
                                color: root.alpha(theme.fg, 0.5)
                            }

                        }

                        Row {
                            property int totalSegs: 24
                            property int activeSegs: Math.round((root.diskUsage / 100) * totalSegs)

                            Layout.fillWidth: true
                            height: 12
                            spacing: 3

                            Repeater {
                                model: parent.totalSegs

                                Rectangle {
                                    width: (parent.width - (parent.spacing * (parent.totalSegs - 1))) / parent.totalSegs
                                    height: parent.height
                                    radius: 2
                                    color: index < parent.activeSegs ? theme.green : root.alpha(theme.fg, 0.1)
                                    opacity: index < parent.activeSegs ? 1 : 0.5

                                    Rectangle {
                                        anchors.fill: parent
                                        radius: 2
                                        color: theme.green
                                        opacity: index < parent.activeSegs ? 0.4 : 0
                                        visible: index < parent.activeSegs
                                        border.width: 0
                                    }

                                }

                            }

                        }

                    }

                }

            }

        }

    }

}
