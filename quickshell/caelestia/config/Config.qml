pragma Singleton

import "root:/utils"
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property alias appearance: adapter.appearance
    property alias general: adapter.general
    property alias background: adapter.background
    property alias bar: adapter.bar
    property alias border: adapter.border
    property alias dashboard: adapter.dashboard
    property alias controlCenter: adapter.controlCenter
    property alias launcher: adapter.launcher
    property alias notifs: adapter.notifs
    property alias osd: adapter.osd
    property alias session: adapter.session
    property alias winfo: adapter.winfo
    property alias lock: adapter.lock
    property alias utilities: adapter.utilities
    property alias sidebar: adapter.sidebar
    property alias services: adapter.services
    property alias paths: adapter.paths

    FileView {
        path: `${Paths.config}/shell.json`
        watchChanges: true
        onFileChanged: reload()
        onAdapterUpdated: writeAdapter()

        JsonAdapter {
            id: adapter

            property JsonObject appearance: AppearanceConfig {}
            property JsonObject general: GeneralConfig {}
            property JsonObject background: BackgroundConfig {}
            property JsonObject bar: BarConfig {}
            property JsonObject border: BorderConfig {}
            property JsonObject dashboard: DashboardConfig {}
            property JsonObject controlCenter: ControlCenterConfig {}
            property JsonObject launcher: LauncherConfig {}
            property JsonObject notifs: NotifsConfig {}
            property JsonObject osd: OsdConfig {}
            property JsonObject session: SessionConfig {}
            property JsonObject winfo: WInfoConfig {}
            property JsonObject lock: LockConfig {}
            property JsonObject utilities: UtilitiesConfig {}
            property JsonObject sidebar: SidebarConfig {}
            property JsonObject services: ServiceConfig {}
            property JsonObject paths: UserPaths {}
        }
    }
}
