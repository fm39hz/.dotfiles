pragma Singleton

import "root:/utils/scripts/fuzzysort.js" as Fuzzy
import Quickshell
import Quickshell.Io
import "root:/utils" // For Paths.config

Singleton {
    id: root

    // FileView to manage app_stats.json for persistent storage
    FileView {
        id: appStatsFileView
        // Use Paths.config to get the configuration directory
        path: `${Paths.config}/app_stats.json`
        watchChanges: true // Watch for external changes to the file

        // JsonAdapter to hold the actual data
        JsonAdapter {
            id: appStatsAdapter
            property var appFrequency: ({}) // Map of app ID to launch count
            property var appLastUsed: ({})  // Map of app ID to timestamp
        }

        // When the adapter's properties are updated, write to file
        onAdapterUpdated: appStatsFileView.writeAdapter()

        // When the file changes externally, reload the adapter
        onFileChanged: appStatsFileView.reload()
    }

    // Expose the appStatsAdapter as usageStats for compatibility with existing code
    readonly property var usageStats: appStatsAdapter

    readonly property list<DesktopEntry> list: DesktopEntries.applications.values.filter(a => !a.noDisplay).sort((a, b) => {
        // Sort by frequency first, then by name
        const freqA = usageStats.appFrequency[a.id] || 0;
        const freqB = usageStats.appFrequency[b.id] || 0;

        if (freqB !== freqA) {
            return freqB - freqA; // Higher frequency first
        }

        return a.name.localeCompare(b.name);
    })

    readonly property list<var> preppedApps: list.map(a => ({
                name: Fuzzy.prepare(a.name),
                comment: Fuzzy.prepare(a.comment),
                genericName: Fuzzy.prepare(a.genericName),
                keywords: Fuzzy.prepare(a.keywords.join(" ")),
                entry: a,
                frequency: usageStats.appFrequency[a.id] || 0
            }))

    function fuzzyQuery(search: string): var { // Idk why list<DesktopEntry> doesn't work
        const results = Fuzzy.go(search, preppedApps, {
            all: true,
            keys: ["name", "genericName", "comment", "keywords"],
            scoreFn: r => {
                const nameScore = r[0].score > 0 ? r[0].score : 0;
                const genericScore = r[1].score > 0 ? r[1].score : 0;
                const commentScore = r[2].score > 0 ? r[2].score : 0;
                const keywordsScore = r[3].score > 0 ? r[3].score : 0;
                return nameScore * 0.5 + genericScore * 0.2 + commentScore * 0.15 + keywordsScore * 0.15;
            }
        });

        // Boost score based on frequency
        return results.map(r => {
            const freq = r.obj.frequency;
            if (freq > 0) {
                // Boost score based on usage frequency (logarithmic scale)
                const frequencyBoost = Math.log(freq + 1) * 0.1;
                r.score += frequencyBoost;
            }
            return r;
        }).sort((a, b) => b.score - a.score).map(r => r.obj.entry);
    }

    function launch(entry: DesktopEntry): void {
        // Track app usage by updating the properties of the JsonAdapter
        // Create new objects to ensure reactivity and trigger updates
        const newFrequency = Object.assign({}, usageStats.appFrequency);
        newFrequency[entry.id] = (newFrequency[entry.id] || 0) + 1;
        usageStats.appFrequency = newFrequency; // This assignment triggers onAdapterUpdated

        const newLastUsed = Object.assign({}, usageStats.appLastUsed);
        newLastUsed[entry.id] = Date.now();
        usageStats.appLastUsed = newLastUsed; // This assignment triggers onAdapterUpdated

        // Launch the app
        if (entry.execString.startsWith("sh -c"))
            Quickshell.execDetached(["sh", "-c", `app2unit -- ${entry.execString}`]);
        else
            Quickshell.execDetached(["sh", "-c", `app2unit -- '${entry.id}.desktop' || app2unit -- ${entry.execString}`]);
    }
}
