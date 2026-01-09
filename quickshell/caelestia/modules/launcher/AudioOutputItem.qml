import "root:/widgets"
import "root:/services"
import "root:/config"
import QtQuick

Item {
    id: root

    required property AudioOutputs.AudioOutput modelData
    required property var list

    implicitHeight: Config.launcher.sizes.itemHeight

    anchors.left: parent?.left
    anchors.right: parent?.right

    StateLayer {
        radius: Appearance.rounding.full

        function onClicked(): void {
            root.modelData?.onClicked(root.list);
        }
    }

    Item {
        anchors.fill: parent
        anchors.leftMargin: Appearance.padding.larger
        anchors.rightMargin: Appearance.padding.larger
        anchors.margins: Appearance.padding.smaller

        MaterialIcon {
            id: icon

            text: root.modelData.isDefault ? "volume_up" : "volume_down"
            font.pointSize: Appearance.font.size.extraLarge

            anchors.verticalCenter: parent.verticalCenter
        }

        StyledText {
            id: name

            anchors.left: icon.right
            anchors.leftMargin: Appearance.spacing.larger
            anchors.verticalCenter: icon.verticalCenter
            
            text: root.modelData?.name ?? ""
            font.pointSize: Appearance.font.size.normal
            width: parent.width - icon.width - name.anchors.leftMargin
            elide: Text.ElideRight
        }
    }
}
