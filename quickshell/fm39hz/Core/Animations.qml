import QtQuick
pragma Singleton

QtObject {
    readonly property int fast: 200
    readonly property int medium: 300
    readonly property int slow: 400
    readonly property int standardEasing: Easing.OutCubic
    readonly property int enterEasing: Easing.OutBack
    readonly property int exitEasing: Easing.InCubic
}
