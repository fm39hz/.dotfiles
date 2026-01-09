import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

SettingItem {
    id: root

    property bool active: false

    ToggleSwitch {
        checked: root.active
        colors: root.colors
        onCheckedChanged: {
            if (root.active !== checked)
                root.active = checked;

        }
    }

}
