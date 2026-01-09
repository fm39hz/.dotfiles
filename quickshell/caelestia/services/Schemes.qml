pragma Singleton

import "root:/utils/scripts/fuzzysort.js" as Fuzzy
import "root:/config"
import "root:/utils"
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property var allSchemes: ({}) // { "schemename": { "flavour": ... } }
    onAllSchemesChanged: {
        setScheme(currentScheme.name, currentScheme.flavour);
    }

    readonly property list<string> colourNames: ["rosewater", "flamingo", "pink", "mauve", "red", "maroon", "peach", "yellow", "green", "teal", "sky", "sapphire", "blue", "lavender"]

    PersistentProperties {
        id: currentScheme
        property string name: "everforest"
        property string flavour: "dark"
        property bool light: false
    }

    PersistentProperties {
        id: currentPalette
        property color m3primary_paletteKeyColor
        property color m3secondary_paletteKeyColor
        property color m3tertiary_paletteKeyColor
        property color m3neutral_paletteKeyColor
        property color m3neutral_variant_paletteKeyColor
        property color m3background
        property color m3onBackground
        property color m3surface
        property color m3surfaceDim
        property color m3surfaceBright
        property color m3surfaceContainerLowest
        property color m3surfaceContainerLow
        property color m3surfaceContainer
        property color m3surfaceContainerHigh
        property color m3surfaceContainerHighest
        property color m3onSurface
        property color m3surfaceVariant
        property color m3onSurfaceVariant
        property color m3inverseSurface
        property color m3inverseOnSurface
        property color m3outline
        property color m3outlineVariant
        property color m3shadow
        property color m3scrim
        property color m3surfaceTint
        property color m3primary
        property color m3onPrimary
        property color m3primaryContainer
        property color m3onPrimaryContainer
        property color m3inversePrimary
        property color m3secondary
        property color m3onSecondary
        property color m3secondaryContainer
        property color m3onSecondaryContainer
        property color m3tertiary
        property color m3onTertiary
        property color m3tertiaryContainer
        property color m3onTertiaryContainer
        property color m3error
        property color m3onError
        property color m3errorContainer
        property color m3onErrorContainer
        property color m3primaryFixed
        property color m3primaryFixedDim
        property color m3onPrimaryFixed
        property color m3onPrimaryFixedVariant
        property color m3secondaryFixed
        property color m3secondaryFixedDim
        property color m3onSecondaryFixed
        property color m3onSecondaryFixedVariant
        property color m3tertiaryFixed
        property color m3tertiaryFixedDim
        property color m3onTertiaryFixed
        property color m3onTertiaryFixedVariant
        property color rosewater
        property color flamingo
        property color pink
        property color mauve
        property color red
        property color maroon
        property color peach
        property color yellow
        property color green
        property color teal
        property color sky
        property color sapphire
        property color blue
        property color lavender
    }

    readonly property var currentSchemeData: allSchemes[currentScheme.name]?.[currentScheme.flavour]

    Repeater {
        model: {
            const files = schemeFiles.text.trim().split("\n").filter(p => p);
            return files;
        }
        delegate: FileView {
            path: modelData
            onLoaded: {
                console.log("FileView loaded:", path);
                console.log("File content (text):", text);
                const name = path.slice(path.lastIndexOf("/") + 1, path.lastIndexOf("."));
                const data = JSON.parse(text);
                console.log("Parsed JSON data:", data);
                const newSchemes = Object.assign({}, root.allSchemes);
                newSchemes[name] = data;
                root.allSchemes = newSchemes;
            }
        }
    }

    Process {
        id: schemeFiles
        running: true
        command: ["find", Paths.strip(Paths.config) + "/config/schemes", "-name", "\"*.json\""]
    }

    readonly property list<var> flatSchemeList: {
        const flat = [];
        for (const [name, scheme] of Object.entries(allSchemes)) {
            for (const [flavour, data] of Object.entries(scheme)) {
                flat.push({ name: name, flavour: flavour, colours: data.colours });
            }
        }
        return flat;
    }

    readonly property list<var> preppedSchemes: flatSchemeList.map(s => ({
                name: Fuzzy.prepare(s.name),
                flavour: Fuzzy.prepare(s.flavour),
                scheme: s
            }))

    function fuzzyQuery(search: string): var {
        const query = search.slice(`${Config.launcher.actionPrefix}scheme `.length);
        if (!query) return flatSchemeList;
        return Fuzzy.go(query, preppedSchemes, {
            all: true,
            keys: ["name", "flavour"],
            scoreFn: r => r[0].score > 0 ? r[0].score * 0.9 + r[1].score * 0.1 : 0
        }).map(r => r.obj.scheme);
    }

    function setScheme(name, flavour) {
        const schemeData = allSchemes[name]?.[flavour];
        if (schemeData) {
            currentScheme.name = name;
            currentScheme.flavour = flavour;
            currentScheme.light = schemeData.mode === "light";
            
            const colours = schemeData.colours;
            for (const [key, colour] of Object.entries(colours)) {
                const propName = colourNames.includes(key) ? key : `m3${key}`;
                if (currentPalette.hasOwnProperty(propName)) {
                    currentPalette[propName] = `#${colour}`;
                }
            }
        } else if (allSchemes[name]) {
            // If flavour doesn't exist, try to find another one.
            const availableFlavours = Object.keys(allSchemes[name]);
            if (availableFlavours.length > 0) {
                setScheme(name, availableFlavours[0]);
            }
        }
    }

    component Scheme: QtObject {
        required property var modelData
        readonly property string name: modelData.name
        readonly property string flavour: modelData.flavour
        readonly property var colours: modelData.colours

        function onClicked(list: AppList): void {
            list.visibilities.launcher = false;
            root.setScheme(name, flavour);
        }
    }
}
