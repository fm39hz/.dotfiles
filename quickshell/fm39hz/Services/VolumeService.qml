import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

import qs.Core
Item {
    id: root

    PwObjectTracker {
        objects: sinks
    }

    readonly property var sinks: Pipewire.nodes.values.reduce((acc, node) => {
        if (!node.isStream && node.isSink && node.audio) {
            acc.push(node);
        }
        return acc;
    }, [])

    readonly property PwNode sink: {
        if (!Pipewire.ready) return null;
        
        let defaultSink = Pipewire.defaultAudioSink;
        
        if (defaultSink && !defaultSink.isStream && defaultSink.isSink && defaultSink.audio) {
            return defaultSink;
        }
        
        return sinks.length > 0 ? sinks[0] : null;
    }

    readonly property bool ready: !!sink
    readonly property real volume: sink?.audio?.volume ?? 0
    readonly property bool muted: sink?.audio?.muted ?? false
    readonly property string description: sink?.description ?? "Audio Output"
    
    readonly property int level: Math.round(volume * 100)

    readonly property string icon: {
        if (muted) return Icons.volumeMuted;
        const v = volume;
        if (v <= 0) return Icons.volumeZero;
        if (v < 0.33) return Icons.volumeLow;
        if (v < 0.66) return Icons.volumeMedium;
        return Icons.volumeHigh;
    }

    function setVolume(v) {
        if (sink && sink.audio) {
            if (sink.audio.muted) sink.audio.muted = false;
            sink.audio.volume = v;
        }
    }
    
    function toggleMute() {
        if (sink && sink.audio) {
            sink.audio.muted = !sink.audio.muted;
        }
    }
    
    function increaseVolume(amount = 0.05) {
        setVolume(Math.min(1.0, volume + amount));
    }
    
    function decreaseVolume(amount = 0.05) {
        setVolume(Math.max(0.0, volume - amount));
    }
}
