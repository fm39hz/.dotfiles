pragma Singleton

import "root:/utils/scripts/fuzzysort.js" as Fuzzy
import "root:/config"
import "root:/services"
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    readonly property list<var> preppedOutputs: outputs.instances.map(s => ({
                name: Fuzzy.prepare(s.name),
                output: s
            }))

    function fuzzyQuery(search: string): var {
        const query = search.slice(`${Config.launcher.actionPrefix}output `.length)
        if (!query) return preppedOutputs.map(p => p.output)
        return Fuzzy.go(query, preppedOutputs, {
            all: true,
            key: "name"
        }).map(r => r.obj.output);
    }

    function reload() {
        getOutputs.running = true
    }

    Variants {
        id: outputs

        AudioOutput {}
    }

    Process {
        id: getOutputs

        command: ["pactl", "list", "sinks"]
        stdout: StdioCollector {
            onStreamFinished: {
                const sinks = [];
                let currentSink = null;
                const lines = text.split('\n');

                for (const line of lines) {
                    const trimmedLine = line.trim();
                    if (trimmedLine.startsWith("Sink #")) {
                        if (currentSink) {
                            sinks.push(currentSink);
                        }
                        currentSink = {
                            id: parseInt(trimmedLine.split("#")[1]),
                            name: "",
                            isDefault: false
                        };
                    } else if (trimmedLine.startsWith("Description:") && currentSink) {
                        currentSink.name = trimmedLine.substring(trimmedLine.indexOf(":") + 1).trim();
                    } else if (trimmedLine.startsWith("State: RUNNING") && currentSink) {
                        currentSink.isDefault = true;
                    }
                }
                if (currentSink) {
                    sinks.push(currentSink);
                }

                // Adjust names to mark the default sink
                for (const sink of sinks) {
                    if (sink.isDefault) {
                        sink.name += " - Default";
                    }
                }

                outputs.model = sinks;
            }
        }
    }

    Component.onCompleted: reload()

    component AudioOutput: QtObject {
        required property var modelData
        readonly property int id: modelData.id
        readonly property string name: modelData.name
        readonly property bool isDefault: modelData.isDefault

        function onClicked(list: AppList): void {
            list.visibilities.launcher = false;
            Quickshell.execDetached(["pactl", "set-default-sink", id.toString()]);
            // Also need to move the streams to the new sink
            const moveStreamsCmd = "for i in $(pactl list short sink-inputs | awk '{print $1}'); do pactl move-sink-input $i " + id.toString() + "; done";
            Quickshell.execDetached(["sh", "-c", moveStreamsCmd]);
            Audio.sink.changed();
            root.reload();
        }
    }
}
