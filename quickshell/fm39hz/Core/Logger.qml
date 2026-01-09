pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root

    function _formatMessage(level, color, ...args) {
        var t = Qt.formatTime(new Date(), "hh:mm:ss.zzz");
        var prefix = `\x1b[36m[${t}]\x1b[0m`;
        
        if (args.length > 1) {
            const maxLength = 14;
            var module = args.shift().toString().substring(0, maxLength).padStart(maxLength, " ");
            return `${prefix} ${color}${module}\x1b[0m ` + args.join(" ");
        } else {
            return `${prefix} ` + args.join(" ");
        }
    }

    function _getStackTrace() {
        try {
            throw new Error("Stack trace");
        } catch (e) {
            return e.stack;
        }
    }

    property bool debugEnabled: false

    function d(...args) {
        if (debugEnabled) {
            var msg = _formatMessage("DEBUG", "\x1b[35m", ...args);
            console.debug(msg);
        }
    }

    function i(...args) {
        var msg = _formatMessage("INFO", "\x1b[32m", ...args);
        console.info(msg);
    }

    function w(...args) {
        var msg = _formatMessage("WARN", "\x1b[33m", ...args);
        console.warn(msg);
    }

    function e(...args) {
        var msg = _formatMessage("ERROR", "\x1b[31m", ...args);
        console.error(msg);
    }

    function callStack() {
        var stack = _getStackTrace();
        Logger.i("Debug", "--------------------------");
        Logger.i("Debug", "Current call stack");
        var stackLines = stack.split('\n');
        for (var i = 0; i < stackLines.length; i++) {
            var line = stackLines[i].trim();
            if (line.length > 0) {
                Logger.i("Debug", `- ${line}`);
            }
        }
        Logger.i("Debug", "--------------------------");
    }
}
