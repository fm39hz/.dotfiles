import QtQuick
import Quickshell
import Quickshell.Io
pragma Singleton

Singleton {
    id: root

    signal matugenFinished(int code)
    signal thumbnailGenerationFinished(int code)
    signal openRgbFinished(int code)
    signal openRgbDevicesListFetched(string output)
    signal wallpaperCopyFinished(int code)
    signal dirCreationFinished(int code)
    signal userNameFetched(string name)
    signal osNameFetched(string name)
    signal hostNameFetched(string name)
    signal kernelVersionFetched(string version)
    signal shellNameFetched(string name)
    signal wmNameFetched(string name)
    signal uptimeFetched(string uptime)

    function createDirs() {
        dirCreator.running = true;
    }

    function runMatugen(cmd) {
        matugenProcess.command = ["sh", "-c", cmd];
        matugenProcess.running = true;
    }

    function generateThumbnails(scriptPath, srcDir, destDir) {
        thumbnailGenerator.command = ["python3", scriptPath, srcDir, destDir];
        thumbnailGenerator.running = true;
    }

    function runOpenRgb(args) {
        keyboardRgb.command = args;
        keyboardRgb.running = true;
    }

    function listOpenRgbDevices() {
        openRgbListProc.running = true;
    }

    function copyWallpaper(src, dest) {
        wallpaperCopier.command = ["cp", src, dest];
        wallpaperCopier.running = true;
    }

    function fetchSystemInfo() {
        userProc.running = true;
        osProc.running = true;
        hostProc.running = true;
        kernelProc.running = true;
        shellProc.running = true;
        wmProc.running = true;
        uptimeProc.running = true;
    }

    function fetchUptime() {
        uptimeProc.running = true;
    }

    function togglePowerMenu() {
        powerMenuProc.running = true;
    }

    Process {
        id: dirCreator

        command: ["mkdir", "-p", Quickshell.env("HOME") + "/.cache/mannu"]
        running: false
        onExited: (code, status) => {
            return root.dirCreationFinished(code);
        }
    }

    Process {
        id: matugenProcess

        running: false
        onExited: (code, status) => {
            return root.matugenFinished(code);
        }
    }

    Process {
        id: thumbnailGenerator

        running: false
        onExited: (code, status) => {
            return root.thumbnailGenerationFinished(code);
        }
    }

    Process {
        id: keyboardRgb

        running: false
        onExited: (code, status) => {
            return root.openRgbFinished(code);
        }
    }

    Process {
        id: openRgbListProc

        property string accumulatedOutput: ""

        command: ["openrgb", "--list-devices"]
        running: false
        onExited: (code, status) => {
            if (code === 0)
                root.openRgbDevicesListFetched(accumulatedOutput);
            else
                Logger.e("Ipc", "OpenRGB list devices failed with code " + code);
            accumulatedOutput = ""; // Reset for next run
        }

        stdout: SplitParser {
            onRead: (data) => {
                return openRgbListProc.accumulatedOutput += data + "\n";
            }
        }

    }

    Process {
        id: wallpaperCopier

        running: false
        onExited: (code, status) => {
            return root.wallpaperCopyFinished(code);
        }
    }

    Process {
        id: powerMenuProc

        command: ["quickshell", "ipc", "-c", "mannu", "call", "powermenu", "toggle"]
        running: false
    }

    Process {
        id: userProc

        command: ["whoami"]

        stdout: SplitParser {
            onRead: (data) => {
                if (data)
                    root.userNameFetched(data.trim());

            }
        }

    }

    Process {
        id: osProc

        command: ["sh", "-c", "grep PRETTY_NAME /etc/os-release | cut -d'=' -f2 | tr -d '\"'"]

        stdout: SplitParser {
            onRead: (data) => {
                if (data)
                    root.osNameFetched(data.trim());

            }
        }

    }

    Process {
        id: hostProc

        command: ["cat", "/proc/sys/kernel/hostname"]

        stdout: SplitParser {
            onRead: (data) => {
                if (data && data.trim() !== "")
                    root.hostNameFetched(data.trim());

            }
        }

    }

    Process {
        id: kernelProc

        command: ["uname", "-r"]

        stdout: SplitParser {
            onRead: (data) => {
                if (data)
                    root.kernelVersionFetched(data.trim());

            }
        }

    }

    Process {
        id: shellProc

        command: ["sh", "-c", "echo $SHELL | awk -F/ '{print $NF}'"]

        stdout: SplitParser {
            onRead: (data) => {
                if (data)
                    root.shellNameFetched(data.trim());

            }
        }

    }

    Process {
        id: wmProc

        command: ["sh", "-c", "echo $XDG_CURRENT_DESKTOP"]

        stdout: SplitParser {
            onRead: (data) => {
                if (data && data.trim() !== "")
                    root.wmNameFetched(data.trim());

            }
        }

    }

    Process {
        id: uptimeProc

        command: ["uptime", "-p"]

        stdout: SplitParser {
            onRead: (data) => {
                if (data)
                    root.uptimeFetched(data.replace("up ", "").trim());

            }
        }

    }

}
