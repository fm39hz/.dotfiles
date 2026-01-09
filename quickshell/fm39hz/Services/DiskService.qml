import QtQuick
import Quickshell.Io

Item {
    property real usage: 0
    property real free: 0
    property real total: 0

    Process {
        id: diskProc

        command: ["sh", "-c", "df -k / | tail -1"]

        stdout: SplitParser {
            onRead: (data) => {
                if (!data)
                    return ;

                var parts = data.trim().split(/\s+/);
                var totalK = parseFloat(parts[1]) || 0;
                var freeK = parseFloat(parts[3]) || 0;
                var percentStr = parts[4] || "0%";
                total = totalK * 1024;
                free = freeK * 1024;
                usage = parseInt(percentStr.replace('%', '')) || 0;
            }
        }

    }

    Timer {
        interval: 1500
        running: true
        repeat: true
        onTriggered: diskProc.running = true
    }

}
