pragma Singleton

import "root:/config"
import "root:/utils"
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    readonly property list<string> colourNames: ["rosewater", "flamingo", "pink", "mauve", "red", "maroon", "peach", "yellow", "green", "teal", "sky", "sapphire", "blue", "lavender"]

    property bool showPreview
    property string scheme: "everforest"
    property string flavour: "dark"
    property bool light: false
    readonly property Colours palette: showPreview ? preview : current
    readonly property Colours current: Colours {}
    readonly property Colours preview: Colours {}
    readonly property Transparency transparency: Transparency {}

    function alpha(c: color, layer: bool): color {
        if (!transparency.enabled)
            return c;
        c = Qt.rgba(c.r, c.g, c.b, layer ? transparency.layers : transparency.base);
        if (layer)
            c.hsvValue = Math.max(0, Math.min(1, c.hslLightness + (light ? -0.2 : 0.2)));
        return c;
    }

    function on(c: color): color {
        if (c.hslLightness < 0.5)
            return Qt.hsla(c.hslHue, c.hslSaturation, 0.9, 1);
        return Qt.hsla(c.hslHue, c.hslSaturation, 0.1, 1);
    }

    function load(data: string, isPreview: bool): void {
        const colours = isPreview ? preview : current;
        const scheme = JSON.parse(data);

        if (!isPreview) {
            root.scheme = scheme.name;
            flavour = scheme.flavour;
        }

        light = scheme.mode === "light";

        for (const [name, colour] of Object.entries(scheme.colours)) {
            const propName = colourNames.includes(name) ? name : `m3${name}`;
            if (colours.hasOwnProperty(propName))
                colours[propName] = `#${colour}`;
        }
    }

    function setMode(mode: string): void {
        if (mode === "light") {
            loadEverforestLight();
        } else {
            loadEverforestDark();
        }
    }

    function loadEverforestDark(): void {
        const everforestDark = {
            "name": "everforest",
            "flavour": "dark",
            "mode": "dark",
            "colours": {
                // Base colors from terminal_color variables
                "m3background": "2d353b",          // Dark forest background
                "m3onBackground": "d3c6aa",        // Light cream text
                "m3surface": "343f44",             // Slightly lighter surface
                "m3surfaceDim": "2d353b",          // Same as background
                "m3surfaceBright": "3d484d",       // Brighter surface
                "m3surfaceContainerLowest": "1e2326", // Darker surface
                "m3surfaceContainerLow": "2e383c",  // Low surface
                "m3surfaceContainer": "374145",     // Normal container
                "m3surfaceContainerHigh": "414b50", // High container
                "m3surfaceContainerHighest": "4c565c", // Highest container
                "m3onSurface": "d3c6aa",           // Light cream
                "m3surfaceVariant": "4f585e",      // Variant surface
                "m3onSurfaceVariant": "9da9a0",    // Muted text
                "m3inverseSurface": "d3c6aa",      // Inverse
                "m3inverseOnSurface": "2d353b",    // Inverse text
                "m3outline": "859289",             // Outline
                "m3outlineVariant": "4f585e",      // Variant outline
                "m3shadow": "000000",              // Shadow
                "m3scrim": "000000",               // Scrim
                "m3surfaceTint": "a7c080",         // Green tint
                
                // Primary colors (Forest Green)
                "m3primary": "a7c080",             // Green from terminal_color_2
                "m3onPrimary": "2d353b",           // Dark on green
                "m3primaryContainer": "5d7063",     // Darker green container
                "m3onPrimaryContainer": "d3e0c0",   // Light green text
                "m3inversePrimary": "7a8471",      // Inverse primary
                
                // Secondary colors (Sage/Aqua)
                "m3secondary": "83c092",           // Aqua from terminal_color_6
                "m3onSecondary": "2d353b",         // Dark on aqua
                "m3secondaryContainer": "4a5d52",   // Darker aqua container
                "m3onSecondaryContainer": "c1e0c9", // Light aqua text
                
                // Tertiary colors (Blue)
                "m3tertiary": "7fbbb3",            // Blue from terminal_color_4
                "m3onTertiary": "2d353b",          // Dark on blue
                "m3tertiaryContainer": "4a5d57",    // Darker blue container
                "m3onTertiaryContainer": "bfddd9",  // Light blue text
                
                // Error colors (Red)
                "m3error": "e67e80",               // Red from terminal_color_1
                "m3onError": "2d353b",             // Dark on red
                "m3errorContainer": "6b4445",       // Dark red container
                "m3onErrorContainer": "f3bfc0",     // Light red text
                
                // Fixed colors
                "m3primaryFixed": "d3e0c0",        // Fixed green
                "m3primaryFixedDim": "a7c080",     // Dim fixed green
                "m3onPrimaryFixed": "1a2017",      // Dark on fixed
                "m3onPrimaryFixedVariant": "5d7063", // Variant on fixed
                "m3secondaryFixed": "c1e0c9",      // Fixed aqua
                "m3secondaryFixedDim": "83c092",   // Dim fixed aqua
                "m3onSecondaryFixed": "15201a",    // Dark on fixed
                "m3onSecondaryFixedVariant": "4a5d52", // Variant on fixed
                "m3tertiaryFixed": "bfddd9",       // Fixed blue
                "m3tertiaryFixedDim": "7fbbb3",    // Dim fixed blue
                "m3onTertiaryFixed": "142019",     // Dark on fixed
                "m3onTertiaryFixedVariant": "4a5d57", // Variant on fixed
                
                // Catppuccin-style colors using Everforest palette
                "rosewater": "d699b6",             // Pink from terminal_color_5
                "flamingo": "e67e80",              // Red
                "pink": "d699b6",                  // Pink
                "mauve": "d699b6",                 // Purple-pink
                "red": "e67e80",                   // Red
                "maroon": "d695a6",               // Maroon variant
                "peach": "e69875",                // Orange variant
                "yellow": "dbbc7f",               // Yellow from terminal_color_3
                "green": "a7c080",                // Green
                "teal": "83c092",                 // Teal/Aqua
                "sky": "7fbbb3",                  // Sky blue
                "sapphire": "7fbbb3",             // Sapphire
                "blue": "7fbbb3",                 // Blue
                "lavender": "d699b6"              // Lavender
            }
        };
        
        load(JSON.stringify(everforestDark), false);
    }

    function loadEverforestLight(): void {
        const everforestLight = {
            "name": "everforest",
            "flavour": "light",
            "mode": "light",
            "colours": {
                // Light theme based on Everforest light variant
                "m3background": "fdf6e3",          // Light cream background
                "m3onBackground": "5c6a72",        // Dark text
                "m3surface": "f4f0d9",             // Light surface
                "m3surfaceDim": "efebd4",          // Dim surface
                "m3surfaceBright": "ffffff",       // Bright surface
                "m3surfaceContainerLowest": "ffffff", // Lowest surface
                "m3surfaceContainerLow": "f8f5de",  // Low surface
                "m3surfaceContainer": "f2efde",     // Normal container
                "m3surfaceContainerHigh": "ece9d8", // High container
                "m3surfaceContainerHighest": "e6e2d3", // Highest container
                "m3onSurface": "5c6a72",           // Dark text
                "m3surfaceVariant": "ddd8be",      // Variant surface
                "m3onSurfaceVariant": "708089",    // Muted text
                "m3inverseSurface": "5c6a72",      // Inverse
                "m3inverseOnSurface": "fdf6e3",    // Inverse text
                "m3outline": "a6b0a0",             // Outline
                "m3outlineVariant": "d5d6af",      // Variant outline
                "m3shadow": "000000",              // Shadow
                "m3scrim": "000000",               // Scrim
                "m3surfaceTint": "8da101",         // Green tint
                
                // Primary colors (Forest Green - darker for light theme)
                "m3primary": "8da101",             // Darker green for light theme
                "m3onPrimary": "ffffff",           // White on green
                "m3primaryContainer": "b8d3a7",    // Light green container
                "m3onPrimaryContainer": "2d4016",  // Dark green text
                "m3inversePrimary": "a7c080",      // Inverse primary
                
                // Secondary colors
                "m3secondary": "5a9379",           // Darker aqua for light theme
                "m3onSecondary": "ffffff",         // White on aqua
                "m3secondaryContainer": "a8ceb5",  // Light aqua container
                "m3onSecondaryContainer": "174a2d", // Dark aqua text
                
                // Tertiary colors
                "m3tertiary": "5b9db1",            // Darker blue for light theme
                "m3onTertiary": "ffffff",          // White on blue
                "m3tertiaryContainer": "a4d1dd",   // Light blue container
                "m3onTertiaryContainer": "0f3d47", // Dark blue text
                
                // Error colors
                "m3error": "d44c47",               // Darker red for light theme
                "m3onError": "ffffff",             // White on red
                "m3errorContainer": "f7c7c7",      // Light red container
                "m3onErrorContainer": "4a1617",   // Dark red text
                
                // Catppuccin-style colors (adapted for light theme)
                "rosewater": "dc8a78",
                "flamingo": "dd7878",
                "pink": "ea76cb",
                "mauve": "8839ef",
                "red": "d20f39",
                "maroon": "e64553",
                "peach": "fe640b",
                "yellow": "df8e1d",
                "green": "8da101",
                "teal": "179299",
                "sky": "04a5e5",
                "sapphire": "209fb5",
                "blue": "1e66f5",
                "lavender": "7287fd"
            }
        };
        
        load(JSON.stringify(everforestLight), false);
    }

    Component.onCompleted: {
        // Load Everforest dark theme by default
        loadEverforestDark();
    }

    component Transparency: QtObject {
        readonly property bool enabled: false
        readonly property real base: 0.78
        readonly property real layers: 0.58
    }

    component Colours: QtObject {
        // Material Design 3 colors
        property color m3primary_paletteKeyColor: "#a7c080"
        property color m3secondary_paletteKeyColor: "#83c092"
        property color m3tertiary_paletteKeyColor: "#7fbbb3"
        property color m3neutral_paletteKeyColor: "#5c6a72"
        property color m3neutral_variant_paletteKeyColor: "#708089"
        property color m3background: "#2d353b"
        property color m3onBackground: "#d3c6aa"
        property color m3surface: "#343f44"
        property color m3surfaceDim: "#2d353b"
        property color m3surfaceBright: "#3d484d"
        property color m3surfaceContainerLowest: "#1e2326"
        property color m3surfaceContainerLow: "#2e383c"
        property color m3surfaceContainer: "#374145"
        property color m3surfaceContainerHigh: "#414b50"
        property color m3surfaceContainerHighest: "#4c565c"
        property color m3onSurface: "#d3c6aa"
        property color m3surfaceVariant: "#4f585e"
        property color m3onSurfaceVariant: "#9da9a0"
        property color m3inverseSurface: "#d3c6aa"
        property color m3inverseOnSurface: "#2d353b"
        property color m3outline: "#859289"
        property color m3outlineVariant: "#4f585e"
        property color m3shadow: "#000000"
        property color m3scrim: "#000000"
        property color m3surfaceTint: "#a7c080"
        property color m3primary: "#a7c080"
        property color m3onPrimary: "#2d353b"
        property color m3primaryContainer: "#5d7063"
        property color m3onPrimaryContainer: "#d3e0c0"
        property color m3inversePrimary: "#7a8471"
        property color m3secondary: "#83c092"
        property color m3onSecondary: "#2d353b"
        property color m3secondaryContainer: "#4a5d52"
        property color m3onSecondaryContainer: "#c1e0c9"
        property color m3tertiary: "#7fbbb3"
        property color m3onTertiary: "#2d353b"
        property color m3tertiaryContainer: "#4a5d57"
        property color m3onTertiaryContainer: "#bfddd9"
        property color m3error: "#e67e80"
        property color m3onError: "#2d353b"
        property color m3errorContainer: "#6b4445"
        property color m3onErrorContainer: "#f3bfc0"
        property color m3primaryFixed: "#d3e0c0"
        property color m3primaryFixedDim: "#a7c080"
        property color m3onPrimaryFixed: "#1a2017"
        property color m3onPrimaryFixedVariant: "#5d7063"
        property color m3secondaryFixed: "#c1e0c9"
        property color m3secondaryFixedDim: "#83c092"
        property color m3onSecondaryFixed: "#15201a"
        property color m3onSecondaryFixedVariant: "#4a5d52"
        property color m3tertiaryFixed: "#bfddd9"
        property color m3tertiaryFixedDim: "#7fbbb3"
        property color m3onTertiaryFixed: "#142019"
        property color m3onTertiaryFixedVariant: "#4a5d57"

        // Catppuccin-style colors using Everforest palette
        property color rosewater: "#d699b6"
        property color flamingo: "#e67e80"
        property color pink: "#d699b6"
        property color mauve: "#d699b6"
        property color red: "#e67e80"
        property color maroon: "#d695a6"
        property color peach: "#e69875"
        property color yellow: "#dbbc7f"
        property color green: "#a7c080"
        property color teal: "#83c092"
        property color sky: "#7fbbb3"
        property color sapphire: "#7fbbb3"
        property color blue: "#7fbbb3"
        property color lavender: "#d699b6"
    }
}
