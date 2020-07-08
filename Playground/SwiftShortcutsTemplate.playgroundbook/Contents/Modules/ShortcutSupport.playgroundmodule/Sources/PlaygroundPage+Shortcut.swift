import PlaygroundSupport
import SwiftShortcuts
import UIKit

public extension PlaygroundPage {
    /// Shows a preview of a given shortcut with the ability to share into other apps such as Shortcuts.app.
    ///
    /// - Parameter shortcut: The constructed shortcut to be previewed.
    func show<S: Shortcut>(_ shortcut: S) {
        liveView = ShortcutPreviewViewController(shortcut: shortcut)
    }
}
