import "../Components"
import QtQuick
import QtQuick.Layouts
import qs.Services

BentoCard {
    id: root

    required property var colors
    property var quotes: [{
        "text": "My code doesn't work, I have no idea why. My code works, I have no idea why.",
        "author": "Every Programmer"
    }, {
        "text": "Hardware: The parts of a computer system that can be kicked.",
        "author": "Jeff Pesis"
    }, {
        "text": "There are 10 types of people in the world: Those who understand binary, and those who don't.",
        "author": "Anonymous"
    }, {
        "text": "The best thing about a boolean is even if you are wrong, you are only off by a bit.",
        "author": "Anonymous"
    }, {
        "text": "One man's crappy software is another man's full time job.",
        "author": "Jessica Gaston"
    }, {
        "text": "It works on my machine.",
        "author": "Unknown"
    }, {
        "text": "A computer once beat me at chess, but it was no match for me at kick boxing.",
        "author": "Emo Philips"
    }, {
        "text": "I checked the logs, it says 'Error: Succeeded'.",
        "author": "Anonymous"
    }]
    property var currentQuote: quotes[Math.floor(Math.random() * quotes.length)]

    cardColor: colors.surface
    borderColor: colors.border

    ColumnLayout {
        anchors.centerIn: parent
        width: parent.width - 32
        spacing: 12

        Text {
            text: "\"" + root.currentQuote.text + "\""
            color: root.colors.fg
            font.pixelSize: 14
            font.italic: true
            font.family: "Monospace"
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
        }

        Text {
            text: "~ " + root.currentQuote.author + " ~"
            color: root.colors.muted
            font.pixelSize: 12
            Layout.alignment: Qt.AlignHCenter
        }

    }

    Timer {
        interval: 300000 // 5 mins
        running: true
        repeat: true
        onTriggered: root.currentQuote = root.quotes[Math.floor(Math.random() * root.quotes.length)]
    }

}
