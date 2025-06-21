import "root:/widgets"
import "root:/services"
import "root:/utils"
import "root:/config"
import Quickshell
import Quickshell.Services.UPower
import QtQuick

Item {
    id: root

    property color colour: Colours.palette.m3secondary

    readonly property Item network: network
    readonly property real bs: bluetooth.x
    readonly property real be: repeater.count > 0 ? devices.x + devices.implicitWidth : bluetooth.x + bluetooth.implicitWidth
    readonly property Item battery: battery

    clip: true
    implicitWidth: network.implicitWidth + bluetooth.implicitWidth + bluetooth.anchors.leftMargin + (repeater.count > 0 ? devices.implicitWidth + devices.anchors.leftMargin : 0) + battery.implicitWidth + battery.anchors.leftMargin
    implicitHeight: Math.max(network.implicitHeight, bluetooth.implicitHeight, devices.implicitHeight, battery.implicitHeight)

    MaterialIcon {
        id: network

        animate: true
        text: Network.active ? Icons.getNetworkIcon(Network.active.strength ?? 0) : "󰖪"
        color: root.colour

        anchors.verticalCenter: parent.verticalCenter
    }

    MaterialIcon {
        id: bluetooth

        anchors.verticalCenter: network.verticalCenter
        anchors.left: network.right
        anchors.leftMargin: Appearance.spacing.small

        animate: true
        text: Bluetooth.powered ? "󰂯" : "󰂲"
        color: root.colour
    }

    Row {
        id: devices

        anchors.verticalCenter: bluetooth.verticalCenter
        anchors.left: bluetooth.right
        anchors.leftMargin: Appearance.spacing.small

        spacing: Appearance.spacing.small

        Repeater {
            id: repeater

            model: ScriptModel {
                values: Bluetooth.devices.filter(d => d.connected)
            }

            MaterialIcon {
                required property Bluetooth.Device modelData

                animate: true
                text: Icons.getBluetoothIcon(modelData.icon)
                color: root.colour
            }
        }
    }

MaterialIcon {
    id: battery

    anchors.verticalCenter: devices.verticalCenter
    anchors.left: repeater.count > 0 ? devices.right : bluetooth.right
    anchors.leftMargin: Appearance.spacing.small

    animate: true
    text: {
        if (!UPower.displayDevice.isLaptopBattery) {
            if (PowerProfiles.profile === PowerProfile.PowerSaver)
                return "";
            if (PowerProfiles.profile === PowerProfile.Performance)
                return "";
            return "";
        }

        const perc = UPower.displayDevice.percentage;
        const charging = !UPower.onBattery;
        
        // CUSTOM CHARGING ICONS - Replace these with your preferred icons
        if (charging) {
            if (perc >= 0.95) return "󰂅";      // 95-100%
            else if (perc >= 0.90) return "󰂋";   // 90-95%
            else if (perc >= 0.80) return "󰂊";   // 80-90%
            else if (perc >= 0.70) return "󰢞";   // 70-80%
            else if (perc >= 0.60) return "󰂉";   // 60-70%
            else if (perc >= 0.50) return "󰢝";   // 50-60%
            else if (perc >= 0.40) return "󰂈";   // 40-50%
            else if (perc >= 0.30) return "󰂇";   // 30-40%
            else if (perc >= 0.20) return "󰂆";   // 20-30%
            else return "󰢜";                           // Below 20%
        }
        
        // CUSTOM DISCHARGING ICONS - Replace these with your preferred icons  
        else {
            if (perc >= 0.95) return "󰁹";               // 95-100%
            else if (perc >= 0.90) return "󰂂";         // 90-95%
            else if (perc >= 0.80) return "󰂁";         // 80-90%
            else if (perc >= 0.70) return "󰂀";         // 70-80%
            else if (perc >= 0.60) return "󰁿";         // 60-70%
            else if (perc >= 0.50) return "󰁾";         // 50-60%
            else if (perc >= 0.40) return "󰁽";         // 40-50%
            else if (perc >= 0.30) return "󰁼";         // 30-40%
            else if (perc >= 0.20) return "󰁻";         // 20-30%
            else if (perc >= 0.10) return "󰁺";         // 10-20%
            else return "󰂃";                           // Below 10%
        }
    }
    color: !UPower.onBattery || UPower.displayDevice.percentage > 0.2 ? root.colour : Colours.palette.m3error
    fill: 1
}

    Behavior on implicitWidth {
        NumberAnimation {
            duration: Appearance.anim.durations.normal
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Appearance.anim.curves.emphasized
        }
    }

    Behavior on implicitHeight {
        NumberAnimation {
            duration: Appearance.anim.durations.normal
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Appearance.anim.curves.emphasized
        }
    }
}
