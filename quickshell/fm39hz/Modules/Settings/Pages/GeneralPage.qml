import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.Core
import qs.Services
import qs.Widgets

ColumnLayout {
    property var context // Injected context
    property var colors: context.colors

    spacing: 16

    Text {
        text: "General"
        font.family: Config.fontFamily
        font.pixelSize: 20
        font.bold: true
        color: colors.fg
    }

    SettingItem {
        label: "Font Family"
        sublabel: "Global font family"
        icon: "󰛖"
        colors: context.colors

        TextField {
            Layout.preferredWidth: 250
            Layout.fillWidth: true
            clip: true
            text: Config.fontFamily
            font.family: Config.fontFamily
            font.pixelSize: 14
            color: colors.fg
            horizontalAlignment: TextInput.AlignRight
            onEditingFinished: {
                if (text !== "")
                    Config.fontFamily = text;

            }

            background: Rectangle {
                color: parent.activeFocus ? Qt.rgba(0, 0, 0, 0.2) : "transparent"
                radius: 6
                border.width: parent.activeFocus ? 1 : 0
                border.color: colors.accent
            }

        }

    }

    SettingItem {
        label: "Font Size"
        sublabel: "Global font size"
        icon: "󰛂"
        colors: context.colors

        RowLayout {
            spacing: 12

            Text {
                text: Config.fontSize + "px"
                font.pixelSize: 14
                color: colors.fg
                font.bold: true
            }

            Spincircle {
                symbol: "–"
                onClicked: Config.fontSize = Math.max(10, Config.fontSize - 1)
            }

            Spincircle {
                symbol: "+"
                onClicked: Config.fontSize = Math.min(24, Config.fontSize + 1)
            }

            component Spincircle: Rectangle {
                property string symbol

                signal clicked()

                width: 32
                height: 32
                radius: 16
                color: hover.containsMouse ? colors.tile : "transparent"
                border.width: 1
                border.color: colors.border

                Text {
                    anchors.centerIn: parent
                    text: symbol
                    color: colors.fg
                    font.pixelSize: 16
                }

                TapHandler {
                    onTapped: clicked()
                    cursorShape: Qt.PointingHandCursor
                }

                HoverHandler {
                    id: hover

                    cursorShape: Qt.PointingHandCursor
                }

            }

        }

    }

    // Time & Date Section
    Item {
        Layout.fillWidth: true
        Layout.preferredHeight: 16
    }
    
    Text {
        text: "Time & Date"
        font.family: Config.fontFamily
        font.pixelSize: 18
        font.bold: true
        color: colors.fg
    }

    ToggleButton {
        Layout.fillWidth: true
        label: "24-Hour Format"
        sublabel: "Use 24-hour time format instead of 12-hour"
        icon: "󰖲"
        active: Config.use24HourFormat
        colors: context.colors
        onActiveChanged: {
            if (Config.use24HourFormat !== active)
                Config.use24HourFormat = active;
        }
    }

    SettingItem {
        label: "Time Zone"
        sublabel: "Choose the time zone for displaying time and date"
        icon: "󰃰"
        colors: context.colors

        ComboBox {
            id: tzCombo

            Layout.preferredWidth: 240
            Layout.fillWidth: true
            
            property var filteredTimeZones: {
                if (!context.timezone.timeZones) return [];
                if (searchField.text === "") return context.timezone.timeZones;
                
                var searchText = searchField.text.toLowerCase();
                return context.timezone.timeZones.filter(function(tz) {
                    return tz.toLowerCase().indexOf(searchText) !== -1;
                });
            }
            
            model: filteredTimeZones
            
            currentIndex: {
                if (context.timezone.currentSystemZone === "" || count === 0)
                    return -1;
                return filteredTimeZones.indexOf(context.timezone.currentSystemZone);
            }

            font.family: Config.fontFamily
            font.pixelSize: 14
            
            onActivated: {
                var selected = filteredTimeZones[currentIndex];
                if (selected && selected !== context.timezone.currentSystemZone) {
                    context.timezone.setTimeZone(selected);
                }
            }

            contentItem: Text {
                leftPadding: 12
                rightPadding: tzCombo.indicator.width + tzCombo.spacing
                text: tzCombo.displayText !== "" ? tzCombo.displayText : (context.timezone.timeZones.length === 0 ? "Loading..." : "Select Timezone")
                font: tzCombo.font
                color: colors.fg
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }

            background: Rectangle {
                implicitWidth: 150
                implicitHeight: 36
                color: tzCombo.pressed ? Qt.rgba(0, 0, 0, 0.3) : Qt.rgba(0, 0, 0, 0.2)
                border.color: tzCombo.activeFocus ? colors.accent : colors.border
                border.width: tzCombo.activeFocus ? 2 : 1
                radius: 8
            }

            indicator: Text {
                x: tzCombo.width - width - 12
                y: tzCombo.topPadding + (tzCombo.availableHeight - height) / 2
                text: "󰅀"
                font.family: "Symbols Nerd Font"
                font.pixelSize: 16
                color: colors.fg
            }

            popup: Popup {
                y: tzCombo.height + 4
                width: tzCombo.width
                height: Math.min(tzCombo.model.length * 36 + 70, 340)
                padding: 8

                onOpened: {
                    searchField.text = "";
                    searchField.forceActiveFocus();
                }

                contentItem: ColumnLayout {
                    spacing: 8

                    TextField {
                        id: searchField
                        Layout.fillWidth: true
                        Layout.preferredHeight: 36
                        
                        placeholderText: "Search time zones..."
                        font.family: Config.fontFamily
                        font.pixelSize: 14
                        color: colors.fg

                        background: Rectangle {
                            color: Qt.rgba(0, 0, 0, 0.2)
                            border.color: searchField.activeFocus ? colors.accent : colors.border
                            border.width: searchField.activeFocus ? 2 : 1
                            radius: 6
                        }

                        leftPadding: 36

                        Text {
                            anchors.left: parent.left
                            anchors.leftMargin: 10
                            anchors.verticalCenter: parent.verticalCenter
                            text: ""
                            font.family: "Symbols Nerd Font"
                            font.pixelSize: 16
                            color: colors.fg
                            opacity: 0.5
                        }
                    }

                    ListView {
                        id: timeZoneList
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        clip: true
                        model: tzCombo.popup.visible ? tzCombo.delegateModel : null
                        currentIndex: tzCombo.highlightedIndex

                        ScrollBar.vertical: ScrollBar {
                            active: true
                            policy: ScrollBar.AsNeeded
                            width: 6
                            contentItem: Rectangle {
                                implicitWidth: 6
                                radius: 3
                                color: colors.accent
                                opacity: 0.5
                            }
                        }

                        Text {
                            anchors.centerIn: parent
                            visible: timeZoneList.count === 0 && searchField.text !== ""
                            text: "No time zones found"
                            font.family: Config.fontFamily
                            font.pixelSize: 14
                            color: colors.fg
                            opacity: 0.5
                        }
                    }
                }

                background: Rectangle {
                    color: colors.surface
                    border.color: colors.border
                    border.width: 1
                    radius: 8
                }
            }

            delegate: ItemDelegate {
                width: tzCombo.width - 24
                implicitHeight: 36
                highlighted: tzCombo.highlightedIndex === index

                contentItem: Text {
                    text: modelData
                    font: tzCombo.font
                    color: colors.fg
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: 12
                }

                background: Rectangle {
                    color: parent.highlighted ? colors.tile : "transparent"
                    radius: 6
                }
            }
        }
    }

}
