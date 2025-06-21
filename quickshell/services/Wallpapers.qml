pragma Singleton

import "root:/config"
import "root:/utils/scripts/fuzzysort.js" as Fuzzy
import "root:/utils"
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    readonly property string currentNamePath: Paths.strip(`${Paths.state}/wallpaper/path.txt`)
    readonly property list<string> extensions: ["jpg", "jpeg", "png", "webp", "tif", "tiff"]

    readonly property list<Wallpaper> list: wallpapers.instances
    property bool showPreview: false
    readonly property string current: showPreview ? previewPath : actualCurrent
    property string previewPath
    property string actualCurrent
    property bool previewColourLock

    readonly property list<var> preppedWalls: list.map(w => ({
                name: Fuzzy.prepare(w.name),
                path: Fuzzy.prepare(w.path),
                wall: w
            }))

    function fuzzyQuery(search: string): var {
        return Fuzzy.go(search, preppedWalls, {
            all: true,
            keys: ["name", "path"],
            scoreFn: r => r[0].score * 0.9 + r[1].score * 0.1
        }).map(r => r.obj.wall);
    }

    function setWallpaper(path: string): void {
        actualCurrent = path;
        
        // Save the current wallpaper to our tracking file
        Paths.mkdir(Paths.state + "/wallpaper");
        writeCurrentWallpaper.path = path;
        writeCurrentWallpaper.running = true;
        
        // Apply wallpaper using hyprpaper
        // First preload the wallpaper
        Quickshell.execDetached(["hyprctl", "hyprpaper", "preload", path]);
        
        // Then set it on all monitors (use empty string for all monitors)
        setTimeout(() => {
            Quickshell.execDetached(["hyprctl", "hyprpaper", "wallpaper", `,${path}`]);
        }, 100);
        
        // Optional: Send notification
        Quickshell.execDetached([
            "notify-send", 
            "-a", "Wallpaper", 
            "-i", "image-x-generic",
            "Wallpaper Changed", 
            `Set to ${path.slice(path.lastIndexOf("/") + 1)}`
        ]);
    }

    function preview(path: string): void {
        previewPath = path;
        showPreview = true;
        
        // For preview, we can't easily generate colors without the caelestia tool
        // So we'll skip the color preview or you could implement your own color extraction
        // getPreviewColoursProc.running = true;
    }

    function stopPreview(): void {
        showPreview = false;
        if (!previewColourLock)
            Colours.showPreview = false;
    }

    // Initialize current wallpaper from hyprpaper on startup
    function initializeFromHyprpaper(): void {
        getCurrentWallpaper.running = true;
    }

    Component.onCompleted: {
        // Try to get current wallpaper from hyprpaper
        initializeFromHyprpaper();
    }

    reloadableId: "wallpapers"

    IpcHandler {
        target: "wallpaper"

        function get(): string {
            return root.actualCurrent;
        }

        function set(path: string): void {
            root.setWallpaper(path);
        }

        function list(): string {
            return root.list.map(w => w.path).join("\n");
        }
    }

    // Process to get current wallpaper from hyprpaper
    Process {
        id: getCurrentWallpaper
        
        command: ["hyprctl", "hyprpaper", "listactive"]
        stdout: StdioCollector {
            onStreamFinished: {
                // Parse hyprpaper output to get current wallpaper
                const lines = text.trim().split('\n');
                if (lines.length > 0) {
                    // hyprpaper listactive returns lines like "monitor = wallpaper_path"
                    const firstLine = lines[0];
                    const wallpaperPath = firstLine.split(' = ')[1];
                    if (wallpaperPath && wallpaperPath !== root.actualCurrent) {
                        root.actualCurrent = wallpaperPath;
                        // Update our tracking file
                        writeCurrentWallpaper.path = wallpaperPath;
                        writeCurrentWallpaper.running = true;
                    }
                }
            }
        }
    }

    // Process to write current wallpaper to tracking file
    Process {
        id: writeCurrentWallpaper
        
        property string path: ""
        
        command: ["sh", "-c", `mkdir -p "${Paths.strip(Paths.state)}/wallpaper" && echo "${path}" > "${root.currentNamePath}"`]
    }

    // Watch our tracking file for changes
    FileView {
        path: root.currentNamePath
        watchChanges: true
        onFileChanged: reload()
        onLoaded: {
            const newPath = text().trim();
            if (newPath !== root.actualCurrent) {
                root.actualCurrent = newPath;
            }
            root.previewColourLock = false;
        }
    }

    // Color preview process (optional - remove if you don't need color schemes)
    Process {
        id: getPreviewColoursProc

        command: ["sh", "-c", `
            # Simple color extraction using ImageMagick (if available)
            if command -v magick >/dev/null 2>&1; then
                magick "${root.previewPath}" -resize 1x1 -format '%[pixel:p{0,0}]' info:
            else
                echo '{"colors":{"primary":"#6366f1"}}'
            fi
        `]
        stdout: StdioCollector {
            onStreamFinished: {
                // Simple color scheme generation
                const color = text.trim();
                if (color.startsWith('#')) {
                    const mockScheme = {
                        "name": "preview",
                        "flavour": "dynamic", 
                        "mode": "dark",
                        "colours": {
                            "primary": color,
                            "surface": "#1e1e2e",
                            "onSurface": "#cdd6f4"
                        }
                    };
                    Colours.load(JSON.stringify(mockScheme), true);
                    Colours.showPreview = true;
                }
            }
        }
    }

    Process {
        id: getWallsProc

        running: true
        command: ["find", Config.paths.wallpaperDir, "-type", "d", "-path", '*/.*', "-prune", "-o", "-not", "-name", '.*', "-type", "f", "-print"]
        stdout: StdioCollector {
            onStreamFinished: wallpapers.model = text.trim().split("\n").filter(w => root.extensions.includes(w.slice(w.lastIndexOf(".") + 1))).sort()
        }
    }

    Connections {
        target: Config.paths

        function onWallpaperDirChanged(): void {
            getWallsProc.running = true;
        }
    }

    Variants {
        id: wallpapers

        Wallpaper {}
    }

    component Wallpaper: QtObject {
        required property string modelData
        readonly property string path: modelData
        readonly property string name: path.slice(path.lastIndexOf("/") + 1, path.lastIndexOf("."))
    }

    // Utility function for setTimeout (QML doesn't have native setTimeout)
    function setTimeout(callback, delay) {
        const timer = Qt.createQmlObject("import QtQuick 2.0; Timer {}", root);
        timer.interval = delay;
        timer.repeat = false;
        timer.triggered.connect(function() {
            callback();
            timer.destroy();
        });
        timer.start();
    }
}
