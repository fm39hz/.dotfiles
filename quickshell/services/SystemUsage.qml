pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property real cpuPerc
    property real cpuTemp
    property real gpuPerc
    property real gpuTemp
    property int memUsed
    property int memTotal
    readonly property real memPerc: memTotal > 0 ? memUsed / memTotal : 0
    property int storageUsed
    property int storageTotal
    property real storagePerc: storageTotal > 0 ? storageUsed / storageTotal : 0

    property int lastCpuIdle
    property int lastCpuTotal

    function formatKib(kib: int): var {
        const mib = 1024;
        const gib = 1024 ** 2;
        const tib = 1024 ** 3;

        if (kib >= tib)
            return {
                value: kib / tib,
                unit: "TiB"
            };
        if (kib >= gib)
            return {
                value: kib / gib,
                unit: "GiB"
            };
        if (kib >= mib)
            return {
                value: kib / mib,
                unit: "MiB"
            };
        return {
            value: kib,
            unit: "KiB"
        };
    }

    Timer {
        running: true
        interval: 3000
        repeat: true
        onTriggered: {
            stat.reload();
            meminfo.reload();
            storage.running = true;
            cpuTemp.running = true;
            gpuUsage.running = true;
            gpuTemp.running = true;
        }
    }

    FileView {
        id: stat

        path: "/proc/stat"
        onLoaded: {
            const data = text().match(/^cpu\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)/);
            if (data) {
                const stats = data.slice(1).map(n => parseInt(n, 10));
                const total = stats.reduce((a, b) => a + b, 0);
                const idle = stats[3];

                const totalDiff = total - root.lastCpuTotal;
                const idleDiff = idle - root.lastCpuIdle;
                root.cpuPerc = totalDiff > 0 ? (1 - idleDiff / totalDiff) : 0;

                root.lastCpuTotal = total;
                root.lastCpuIdle = idle;
            }
        }
    }

    FileView {
        id: meminfo

        path: "/proc/meminfo"
        onLoaded: {
            const data = text();
            root.memTotal = parseInt(data.match(/MemTotal: *(\d+)/)[1], 10) || 1;
            root.memUsed = (root.memTotal - parseInt(data.match(/MemAvailable: *(\d+)/)[1], 10)) || 0;
        }
    }

    Process {
        id: storage

        running: true
        command: ["sh", "-c", "df | grep '^/dev/' | awk '{print $1, $3, $4}'"]
        stdout: StdioCollector {
            onStreamFinished: {
                const deviceMap = new Map();

                for (const line of text.trim().split("\n")) {
                    if (line.trim() === "")
                        continue;

                    const parts = line.trim().split(/\s+/);
                    if (parts.length >= 3) {
                        const device = parts[0];
                        const used = parseInt(parts[1], 10) || 0;
                        const avail = parseInt(parts[2], 10) || 0;

                        // Only keep the entry with the largest total space for each device
                        if (!deviceMap.has(device) || (used + avail) > (deviceMap.get(device).used + deviceMap.get(device).avail)) {
                            deviceMap.set(device, {
                                used: used,
                                avail: avail
                            });
                        }
                    }
                }

                let totalUsed = 0;
                let totalAvail = 0;

                for (const [device, stats] of deviceMap) {
                    totalUsed += stats.used;
                    totalAvail += stats.avail;
                }

                root.storageUsed = totalUsed;
                root.storageTotal = totalUsed + totalAvail;
            }
        }
    }

    Process {
        id: cpuTemp

        running: true
        command: ["sh", "-c", "cat /sys/class/thermal/thermal_zone*/temp"]
        stdout: StdioCollector {
            onStreamFinished: {
                const temps = text.trim().split(" ");
                const sum = temps.reduce((acc, d) => acc + parseInt(d, 10), 0);
                root.cpuTemp = sum / temps.length / 1000;
            }
        }
    }

    Process {
        id: gpuInfoDetector
        running: true
        command: ["sh", "-c", "lspci | grep -E 'VGA|3D' | tr '[:upper:]' '[:lower:]'"]
        stdout: StdioCollector {
            onStreamFinished: {
                const textLower = text.trim();

                if (textLower.includes('nvidia')) {
                    root.gpuVendor = 'nvidia';
                } else if (textLower.includes('amd') || textLower.includes('ati')) {
                    root.gpuVendor = 'amd';
                } else if (textLower.includes('intel')) {
                    root.gpuVendor = 'intel';
                } else {
                    root.gpuVendor = 'unknown';
                }

                gpuUsage.running = true;
                gpuTemp.running = true;
            }
        }
    }

    Process {
        id: gpuUsage
        running: false
        command: ["sh", "-c", `
            case "$(lspci | grep -E 'VGA|3D')" in
                *NVIDIA*) nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null || echo 0 ;;
                *AMD*|*ATI*) cat /sys/class/drm/card*/device/gpu_busy_percent 2>/dev/null || echo 0 ;;
                *Intel*) cat /sys/class/drm/card0/gt_busy_percent 2>/dev/null || echo 0 ;;
                *) echo 0 ;;
            esac
        `]
        stdout: StdioCollector {
            onStreamFinished: {
                const vals = text.trim().split(/\s+/).map(v => parseInt(v, 10)).filter(v => !isNaN(v));
                const avg = vals.length ? vals.reduce((a, b) => a + b) / vals.length : 0;
                root.gpuPerc = avg / 100;
            }
        }
    }

    Process {
        id: gpuTemp
        running: false
        command: ["sh", "-c", `
            case "$(lspci | grep -E 'VGA|3D')" in
                *NVIDIA*) nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits 2>/dev/null || echo 0 ;;
                *AMD*|*ATI*) sensors | grep -A1 amdgpu | grep -Eo '[0-9]+\\.[0-9]+' | head -n1 || echo 0 ;;
                *Intel*) sensors | grep -A1 'Package id 0' | grep -Eo '[0-9]+\\.[0-9]+' | head -n1 || echo 0 ;;
                *) echo 0 ;;
            esac
        `]
        stdout: StdioCollector {
            onStreamFinished: {
                const val = parseFloat(text.trim());
                root.gpuTemp = isNaN(val) ? 0 : val;
            }
        }
    }
}
