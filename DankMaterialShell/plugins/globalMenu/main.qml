import QtQuick
import Quickshell
import Quickshell.Io
import qs.Common
import qs.Widgets
import qs.Modules.Plugins
import qs.Services

PluginComponent {
  id: root
  pluginId: "globalMenu"

  property var menuItems: []
  property string menuService: ""
  property string menuPath: ""
  property var currentOpenPopup: null

  // ── Helpers ───────────────────────────────────────────────────
  function busctl(name, ...args) {
    return ["busctl", "--user", "--json=pretty", "call",
      menuService || name, menuPath || "/",
      "com.canonical.dbusmenu", name].concat(args)
  }

  function registrarBusctl(windowId) {
    return ["busctl", "--user", "--json=pretty", "call",
      "com.canonical.AppMenu.Registrar",
      "/com/canonical/AppMenu/Registrar",
      "com.canonical.AppMenu.Registrar",
      "GetMenuForWindow", "u", String(windowId)]
  }

  // ── Process: registrar query ──────────────────────────────────
  Process {
    id: registrarP
    running: false
    stdout: StdioCollector {}
    onExited: function(exit) {
      if (exit !== 0) { clearMenu(); return }
      try {
        var j = JSON.parse(stdout.text)
        if (j && j.data && j.data.length >= 2) {
          menuService = j.data[0]
          menuPath = j.data[1]
          fetchLayout(-1)
        } else clearMenu()
      } catch (e) { clearMenu() }
    }
  }

  // ── Process: get layout ───────────────────────────────────────
  Process {
    id: layoutP
    running: false
    stdout: StdioCollector {}
    onExited: function(exit) {
      if (exit !== 0 || !menuService) { menuItems = []; return }
      try {
        var j = JSON.parse(stdout.text)
        var items = parseLayoutItems(j)
        menuItems = items
      } catch (e) { menuItems = [] }
    }
  }

  // ── Process: trigger event ────────────────────────────────────
  Process {
    id: eventP
    running: false
  }

  // ── Process: get focused window ID (Hyprland) ─────────────────
  Process {
    id: winIdP
    running: false
    stdout: StdioCollector {}
    onExited: function(exit) {
      if (exit !== 0) { clearMenu(); return }
      try { var j = JSON.parse(stdout.text); if (j && j.address) queryRegistrar(j.address); else clearMenu() }
      catch (e) { clearMenu() }
    }
  }

  // ── Parse layout from busctl JSON ─────────────────────────────
  function parseLayoutItems(json) {
    if (!json || !json.data || json.data.length < 2) return []
    var data = json.data
    var revision = data[0]
    var root = data[1]
    return parseNodeChildren(root)
  }

  function parseNodeChildren(node) {
    if (!node || node.length < 4) return []
    var children = node[3]
    if (!Array.isArray(children)) return []
    var result = []
    for (var i = 0; i < children.length; i++) {
      var child = children[i]
      if (!child || child.length < 2) continue
      var id = child[0]
      var label = String(child[1] || "")
      var props = child[2] || {}
      var grandChildren = child[3]
      var isSep = props.type === "separator"
      result.push({
        id: id,
        label: isSep ? "" : label,
        isSeparator: isSep,
        children: Array.isArray(grandChildren) ? parseNodeChildren([0, "", {}, grandChildren]) : []
      })
    }
    return result
  }

  // ── Operations ────────────────────────────────────────────────
  function queryRegistrar(windowId) {
    if (registrarP.running) registrarP.running = false
    registrarP.command = registrarBusctl(windowId)
    registrarP.running = true
  }

  function fetchLayout(parentId) {
    if (!menuService) return
    if (layoutP.running) layoutP.running = false
    layoutP.command = busctl("GetLayout", "i", "i", "as", parentId, -1, 0)
    layoutP.running = true
  }

  function triggerItem(itemId) {
    if (!menuService) return
    eventP.command = ["busctl", "--user", "call",
      menuService, menuPath,
      "com.canonical.dbusmenu", "Event",
      "i", "s", "v", "u",
      String(itemId), "clicked", "u", "0", "0"]
    eventP.running = true
  }

  function refreshMenu() {
    if (CompositorService.isHyprland) {
      if (winIdP.running) winIdP.running = false
      winIdP.command = ["hyprctl", "activewindow", "-j"]
      winIdP.running = true
    } else clearMenu()
  }

  function clearMenu() {
    menuItems = []
    menuService = ""
    menuPath = ""
  }

  // ── Lifecycle ─────────────────────────────────────────────────
  Timer {
    id: initTimer
    interval: 500
    repeat: false
    running: true
    onTriggered: refreshMenu()
  }

  Connections {
    target: CompositorService
    function onToplevelsChanged() { refreshMenu(); dismissPopup() }
  }

  function dismissPopup() {
    if (currentOpenPopup) { currentOpenPopup.hideMenu(); currentOpenPopup.destroy(); currentOpenPopup = null }
  }

  // ── Popup menu ────────────────────────────────────────────────
  Component {
    id: popupC
    PopupWindow {
      id: pop
      property var items: []
      property var anchorItem: null
      visible: false
      color: "transparent"
      anchor.item: anchorItem
      width: 220
      height: Math.min(root.parentScreen?.height * 0.9 ?? 600, flick.contentHeight + Theme.spacingS * 2)
      onImplicitHeightChanged: { if (visible && anchorItem) Qt.callLater(() => pop.anchor.updateAnchor()) }

      Rectangle {
        anchors.fill: parent
        color: Theme.surfaceContainerHigh
        border.color: Theme.surfaceVariant
        border.width: 1
        radius: Theme.cornerRadius
      }

      Flickable {
        id: flick
        anchors.fill: parent
        anchors.margins: Theme.spacingXS
        contentHeight: col.implicitHeight
        interactive: true
        clip: true
        Column {
          id: col
          width: flick.width
          Repeater {
            model: pop.items
            delegate: Item {
              required property var modelData
              width: parent.width
              height: modelData.isSeparator ? 10 : Math.max(28, txt.implicitHeight + Theme.spacingS * 2)
              Rectangle {
                width: parent.width - Theme.spacingXL; height: 1
                color: Theme.surfaceVariant; anchors.centerIn: parent
                visible: modelData.isSeparator
              }
              Rectangle {
                anchors.fill: parent; radius: Theme.cornerRadius - 2
                color: ma.containsMouse ? Theme.surfaceContainerHighest : "transparent"
                visible: !modelData.isSeparator
                Text {
                  id: txt; x: Theme.spacingM; width: parent.width - Theme.spacingM * 2
                  color: Theme.surfaceText; text: modelData.label
                  font.pixelSize: Theme.fontSizeSmall
                  verticalAlignment: Text.AlignVCenter; elide: Text.ElideRight
                  anchors.verticalCenter: parent.verticalCenter
                }
              }
              MouseArea {
                id: ma; anchors.fill: parent; hoverEnabled: true
                enabled: !modelData.isSeparator
                onClicked: {
                  if (modelData.children && modelData.children.length > 0) {
                    fetchLayout(modelData.id)
                    pop.hideMenu(); if (currentOpenPopup === pop) currentOpenPopup = null
                  } else {
                    triggerItem(modelData.id)
                    pop.hideMenu(); if (currentOpenPopup === pop) currentOpenPopup = null
                  }
                }
              }
            }
          }
        }
      }
      Item { anchors.fill: parent; Keys.onEscapePressed: pop.hideMenu() }
      function hideMenu() { visible = false }
    }
  }

  // ── Bar pills ─────────────────────────────────────────────────
  horizontalBarPill: Component {
    Item {
      readonly property bool active: menuItems.length > 0
      implicitWidth: active ? Math.round(row.implicitWidth + Theme.spacingXS * 2) : 0
      implicitHeight: active ? root.barThickness - Theme.spacingXS * 2 : 0
      visible: active
      Rectangle {
        anchors.fill: parent; radius: Theme.cornerRadius
        color: Theme.surfaceContainerHighest; border.color: Theme.surfaceVariant; border.width: 1
        Row {
          id: row; anchors.fill: parent; anchors.margins: Theme.spacingXS; spacing: 0
          Repeater {
            model: menuItems
            delegate: Item {
              required property var modelData
              implicitWidth: t.implicitWidth + Theme.spacingM * 2; implicitHeight: parent.height; height: parent.height
              Rectangle {
                anchors.fill: parent; radius: Theme.cornerRadius - 2
                color: ma.containsMouse ? Theme.surfaceContainerHighest : "transparent"
                Text {
                  id: t; anchors.centerIn: parent; text: modelData.label
                  color: ma.containsMouse ? Theme.primary : Theme.surfaceText; font.pixelSize: Theme.fontSizeSmall
                }
              }
              MouseArea {
                id: ma; anchors.fill: parent; hoverEnabled: true
                onClicked: {
                  if (modelData.children && modelData.children.length > 0) {
                    var p = popupC.createObject(root, { items: modelData.children, anchorItem: ma })
                    if (p) { dismissPopup(); currentOpenPopup = p; p.visible = true; Qt.callLater(() => p.anchor.updateAnchor()) }
                  } else triggerItem(modelData.id)
                }
              }
            }
          }
        }
      }
    }
  }

  verticalBarPill: Component {
    Item {
      readonly property bool active: menuItems.length > 0
      implicitWidth: active ? root.barThickness - Theme.spacingXS * 2 : 0
      implicitHeight: active ? Math.round(cl.implicitHeight + Theme.spacingXS * 2) : 0
      visible: active
      Rectangle {
        anchors.fill: parent; radius: Theme.cornerRadius
        color: Theme.surfaceContainerHighest; border.color: Theme.surfaceVariant; border.width: 1
        Column {
          id: cl; anchors.fill: parent; anchors.margins: Theme.spacingXS; spacing: 0
          Repeater {
            model: menuItems
            delegate: Item {
              required property var modelData
              implicitWidth: parent.width; implicitHeight: tv.implicitHeight + Theme.spacingM; height: implicitHeight
              Rectangle {
                anchors.fill: parent; radius: Theme.cornerRadius - 2
                color: maV.containsMouse ? Theme.surfaceContainerHighest : "transparent"
                Text {
                  id: tv; anchors.centerIn: parent; text: modelData.label
                  color: maV.containsMouse ? Theme.primary : Theme.surfaceText; font.pixelSize: Theme.fontSizeSmall
                }
              }
              MouseArea {
                id: maV; anchors.fill: parent; hoverEnabled: true
                onClicked: {
                  if (modelData.children && modelData.children.length > 0) {
                    var p = popupC.createObject(root, { items: modelData.children, anchorItem: maV })
                    if (p) { dismissPopup(); currentOpenPopup = p; p.visible = true; Qt.callLater(() => p.anchor.updateAnchor()) }
                  } else triggerItem(modelData.id)
                }
              }
            }
          }
        }
      }
    }
  }
}
