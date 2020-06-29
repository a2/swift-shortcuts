import SnapshotTesting
@testable import SwiftShortcuts

extension Snapshotting where Value: Shortcut, Format == String {
    static var shortcut: Snapshotting {
        var snapshotting = Snapshotting<ShortcutPayload, String>.plist.pullback { (shortcut: Value) in
            shortcut.payload
        }
        snapshotting.pathExtension = "shortcut"
        return snapshotting
    }
}
