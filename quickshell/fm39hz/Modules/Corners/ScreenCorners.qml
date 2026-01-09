import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.Core

PanelWindow {
    id: screenCorners

    property var context

    visible: !context.activeWindow.isFullscreen
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.namespace: "quickshell:screenCorners"
    WlrLayershell.layer: WlrLayer.Overlay

    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }

    RoundCorner {
        id: topLeft

        size: 25
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: (!context.config.floatingBar && context.config.barPosition === "top") ? 34 : 0
        corner: RoundCorner.CornerEnum.TopLeft
        color: context.colors.bg
    }

    RoundCorner {
        id: topRight

        size: 25
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: (!context.config.floatingBar && context.config.barPosition === "top") ? 34 : 0
        corner: RoundCorner.CornerEnum.TopRight
        color: context.colors.bg
    }

    RoundCorner {
        id: bottomLeft

        size: 25
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.bottomMargin: (!context.config.floatingBar && context.config.barPosition === "bottom") ? 34 : 0
        corner: RoundCorner.CornerEnum.BottomLeft
        color: context.colors.bg
    }

    RoundCorner {
        id: bottomRight

        size: 25
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: (!context.config.floatingBar && context.config.barPosition === "bottom") ? 34 : 0
        corner: RoundCorner.CornerEnum.BottomRight
        color: context.colors.bg
    }

    mask: Region {
        item: null
    }

}
