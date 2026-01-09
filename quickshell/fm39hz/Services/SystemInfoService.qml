import QtQuick
import Quickshell
import Quickshell.Io
import qs.Core

Item {
    id: root

    property string userName: "User"
    property string osName: "Linux"
    property string hostName: "Localhost"
    property string kernelVersion: "Unknown"
    property string uptime: "Unknown"
    property string shellName: "Unknown"
    property string wmName: "Quickshell"

    Component.onCompleted: Ipc.fetchSystemInfo()

    Connections {
        function onUserNameFetched(name) {
            root.userName = name;
        }

        function onOsNameFetched(name) {
            root.osName = name;
        }

        function onHostNameFetched(name) {
            root.hostName = name;
        }

        function onKernelVersionFetched(name) {
            root.kernelVersion = name;
        }

        function onShellNameFetched(name) {
            root.shellName = name;
        }

        function onWmNameFetched(name) {
            root.wmName = name;
        }

        function onUptimeFetched(time) {
            root.uptime = time;
        }

        target: Ipc
    }

    Timer {
        interval: 60000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: Ipc.fetchUptime()
    }

}
