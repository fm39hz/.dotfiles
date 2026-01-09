import QtQuick
import Quickshell
import Quickshell.Bluetooth
import Quickshell.Io
import qs.Core
pragma Singleton

Singleton {
    id: root

    readonly property BluetoothAdapter adapter: Bluetooth.defaultAdapter
    readonly property bool available: (adapter !== null)
    readonly property bool enabled: (adapter && adapter.enabled !== undefined) ? adapter.enabled : false
    readonly property bool discovering: (adapter && adapter.discovering) ? adapter.discovering : false
    readonly property bool blocked: (adapter && adapter.state === BluetoothAdapterState.Blocked)
    readonly property var devices: adapter ? adapter.devices : null
    readonly property var devicesList: {
        if (!adapter)
            return [];

        var list = (adapter.devices && adapter.devices.values) ? adapter.devices.values : [];
        var globalList = (Bluetooth.devices && Bluetooth.devices.values) ? Bluetooth.devices.values : [];
        return (list.length > 0) ? list : globalList;
    }
    readonly property var connectedDevices: {
        if (!adapter || !adapter.devices)
            return [];

        return adapter.devices.values.filter((dev) => {
            return dev && dev.connected;
        });
    }
    property var btAgent: null
    property bool btAgentRegistered: false
    property bool fallbackAgentAttempted: false

    function startFallbackAgent() {
        if (fallbackAgentAttempted)
            return ;

        fallbackAgentAttempted = true;
        Logger.i("Bluetooth", "Starting fallback bluetoothctl agent");
        fallbackBluetoothctlAgent.running = true;
    }

    function toggleBluetooth() {
        if (adapter)
            adapter.enabled = !adapter.enabled;

    }

    function setBluetoothEnabled(state) {
        if (adapter)
            adapter.enabled = state;

    }

    function startDiscovery() {
        if (adapter && adapter.state === BluetoothAdapterState.Enabled)
            adapter.discovering = true;

    }

    function stopDiscovery() {
        if (adapter)
            adapter.discovering = false;

    }

    function connectDevice(device) {
        if (!device)
            return ;

        Logger.d("Bluetooth", "Connecting to " + (device.name || device.address));
        try {
            device.connect();
        } catch (e) {
            Logger.w("Bluetooth", "Connect failed, trying trust first:", e);
            try {
                device.trusted = true;
                device.connect();
            } catch (e2) {
                Logger.w("Bluetooth", "Connect fallback failed:", e2);
            }
        }
    }

    function disconnectDevice(device) {
        if (device) {
            try {
                device.disconnect();
            } catch (e) {
                Logger.w("Bluetooth", "Disconnect failed:", e);
            }
        }
    }

    function pairDevice(device) {
        if (!device)
            return ;

        Logger.d("Bluetooth", "Pairing " + (device.name || device.address));
        if (!btAgentRegistered) {
            pairWithBluetoothctl(device);
            return ;
        }
        try {
            if (typeof device.pair === 'function') {
                device.pair();
            } else {
                device.trusted = true;
                device.connect();
            }
        } catch (e) {
            Logger.w("Bluetooth", "Pair failed:", e);
            pairWithBluetoothctl(device);
        }
    }

    function unpairDevice(device) {
        if (device) {
            try {
                device.trusted = false;
                device.forget(); // or unpair if available, usually forget()
            } catch (e) {
                Logger.w("Bluetooth", "Unpair failed:", e);
            }
        }
    }

    function pairWithBluetoothctl(device) {
        if (!device)
            return ;

        var addr = device.address || "";
        if (!addr && device.nativePath && device.nativePath.indexOf("dev_") !== -1)
            addr = device.nativePath.split("dev_")[1].replaceAll("_", ":");

        if (!addr || addr.length < 7) {
            Logger.w("Bluetooth", "Invalid address for pairing");
            return ;
        }
        Logger.d("Bluetooth", "Pairing via CLI: " + addr);
        const script = `(
          printf 'agent DisplayYesNo\n';
          printf 'default-agent\n';
          printf 'pair ${addr}\n';
          sleep 2;
          printf 'yes\n';
          printf 'trust ${addr}\n';
          sleep 1;
          printf 'connect ${addr}\n';
          printf 'quit\n';
        ) | bluetoothctl`;
        try {
            Quickshell.execDetached(["sh", "-c", script]);
        } catch (e) {
            Logger.w("Bluetooth", "CLI Pair failed:", e);
        }
    }

    function getDeviceIcon(device) {
        if (!device)
            return "bt-device-generic";

        var name = (device.name || device.deviceName || "").toLowerCase();
        var icon = (device.icon || "").toLowerCase();
        if (icon.indexOf("controller") !== -1 || name.indexOf("controller") !== -1)
            return "bt-device-gamepad";

        if (icon.indexOf("headset") !== -1 || name.indexOf("headset") !== -1 || name.indexOf("buds") !== -1)
            return "bt-device-headset";

        if (icon.indexOf("headphone") !== -1 || name.indexOf("headphone") !== -1)
            return "bt-device-headphones";

        if (icon.indexOf("audio") !== -1 || name.indexOf("speaker") !== -1)
            return "bt-device-speaker";

        if (icon.indexOf("mouse") !== -1 || name.indexOf("mouse") !== -1)
            return "bt-device-mouse";

        if (icon.indexOf("keyboard") !== -1 || name.indexOf("keyboard") !== -1)
            return "bt-device-keyboard";

        if (icon.indexOf("phone") !== -1 || name.indexOf("phone") !== -1)
            return "bt-device-phone";

        return "bt-device-generic";
    }

    Component.onDestruction: {
        if (btAgent)
            btAgent.destroy();

    }
    Component.onCompleted: {
        try {
            const qml = `
import QtQuick
import Quickshell
import Quickshell.Bluetooth

BluetoothAgent {
  id: dynAgent
  capability: BluetoothAgentCapability.KeyboardDisplay

  onRequestConfirmation: function(device, passkey, accept, reject) {
    Logger.d("Bluetooth", "Agent RequestConfirmation: " + passkey);
    accept();
  }

  onRequestPasskey: function(device, accept, reject) {
    Logger.d("Bluetooth", "Agent RequestPasskey");
    reject(); // Not implemented UI for passkey yet
  }

  onRequestPinCode: function(device, accept, reject) {
    Logger.d("Bluetooth", "Agent RequestPinCode");
    reject();
  }

  onDisplayPasskey: function(device, passkey) {
    Logger.d("Bluetooth", "Agent DisplayPasskey: " + passkey);
  }

  onAuthorizeService: function(device, uuid, accept, reject) {
    Logger.d("Bluetooth", "Agent AuthorizeService: " + uuid);
    accept();
  }

  onCancel: function() {
    Logger.d("Bluetooth", "Agent request canceled");
  }
}
`;
            btAgent = Qt.createQmlObject(qml, root, "DynamicBluetoothAgent");
            try {
                Bluetooth.agent = btAgent;
                if (btAgent.register)
                    btAgent.register();

                Logger.d("Bluetooth", "BluetoothAgent registered");
                btAgentRegistered = true;
            } catch (regErr) {
                Logger.w("Bluetooth", "Failed to register agent", regErr);
                btAgentRegistered = false;
                startFallbackAgent();
            }
        } catch (e) {
            Logger.d("Bluetooth", "BluetoothAgent unavailable, using fallback");
            startFallbackAgent();
        }
    }

    Timer {
        id: fallbackForceTimer

        interval: 500
        running: true
        repeat: false
        onTriggered: startFallbackAgent()
    }

    Process {
        id: fallbackBluetoothctlAgent

        command: ["sh", "-c", "(pkill -f '^bt-agent( |$)' 2>/dev/null || true; pkill -f '^bluetoothctl( |$)' 2>/dev/null || true; " + "if command -v bt-agent >/dev/null 2>&1; then exec bt-agent -c DisplayYesNo; " + "else (printf 'agent off\nagent on\nagent KeyboardDisplay\ndefault-agent\n'; while sleep 3600; do :; done) | bluetoothctl; fi)"]
        running: false

        stdout: StdioCollector {
        }

    }

    Timer {
        id: discoveryTimer

        interval: 1000
        repeat: false
        onTriggered: {
            if (adapter && adapter.state === BluetoothAdapterState.Enabled) {
                Logger.d("BluetoothService", "Starting native discovery via Timer");
                adapter.discovering = true;
            }
        }
    }

    Connections {
        function onStateChanged() {
            if (!adapter)
                return ;

            if (adapter.state === BluetoothAdapterState.Enabled)
                discoveryTimer.start();

        }

        function onEnabledChanged() {
            if (adapter && adapter.enabled)
                discoveryTimer.start();

        }

        target: adapter
    }

}
