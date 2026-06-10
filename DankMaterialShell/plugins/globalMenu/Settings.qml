import QtQuick
import qs.Common
import qs.Modules.Plugins

PluginSettings {
  id: root
  pluginId: "globalMenu"

  implicitWidth: parent ? parent.width : 400

  Text {
    width: parent.width
    text: "Global Menu"
    font.pixelSize: Theme.fontSizeLarge
    font.weight: Font.Bold
    color: Theme.surfaceText
  }

  Text {
    width: parent.width
    text: "Display Global Menu on bar using the Canonical appmenu registrar dbus interface"
    font.pixelSize: Theme.fontSizeSmall
    color: Theme.surfaceVariantText
    wrapMode: Text.WordWrap
  }

  Rectangle {
    width: parent.width
    height: infoCol.implicitHeight + Theme.spacingL * 2
    radius: Theme.cornerRadius
    color: Theme.surfaceContainerHigh

    Column {
      id: infoCol
      x: Theme.spacingL
      y: Theme.spacingL
      width: parent.width - Theme.spacingL * 2
      spacing: Theme.spacingM

      Text {
        text: "About"
        font.pixelSize: Theme.fontSizeMedium
        font.weight: Font.Medium
        color: Theme.surfaceText
      }

      Text {
        text: "• Shows menu bar items (File, Edit, View, etc.) for focused XWayland applications\n• Requires com.canonical.AppMenu.Registrar DBus service\n• Works with XWayland apps (Firefox, Thunderbird, Chromium)\n• Navigate submenus by clicking items"
        font.pixelSize: Theme.fontSizeSmall
        color: Theme.surfaceVariantText
        wrapMode: Text.WordWrap
        width: parent.width
        lineHeight: 1.5
      }
    }
  }
}
