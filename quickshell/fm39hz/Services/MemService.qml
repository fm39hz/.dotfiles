import QtQuick
import Quickshell.Io
import qs.Core

Item {
    property real total: 0
    property real used: 0
    property int usage: 0
    property string outputBuffer: ""

    Process {
        id: memProc

        command: ["sh", "-c", "free -b | grep '^Mem:' | awk '{print $2, $3}'"]

        stdout: SplitParser {
            onRead: (data) => {
                if (!data)
                    return ;

                var output = data.trim();
                if (output === "")
                    return ;

                var parts = output.split(/\s+/);
                if (parts.length < 2) {
                    Logger.w("MemService", "Not enough parts");
                    return ;
                }
                var totalBytes = parseInt(parts[0]);
                var usedBytes = parseInt(parts[1]);
                if (isNaN(totalBytes) || isNaN(usedBytes) || totalBytes <= 0) {
                    Logger.e("MemService", "Invalid values");
                    return ;
                }
                total = totalBytes;
                used = usedBytes;
                usage = Math.round((usedBytes / totalBytes) * 100);
            }
        }

    }

    Timer {
        interval: 1500
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            memProc.running = true;
        }
    }

}
