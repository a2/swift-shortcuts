import SwiftShortcuts
import UIKit

class ShortcutWrapper<S: Shortcut>: NSObject, NSItemProviderWriting {
    let shortcut: S

    init(_ shortcut: S) {
        self.shortcut = shortcut
        super.init()
    }

    static var writableTypeIdentifiersForItemProvider: [String] {
        return [
            "com.apple.shortcut"
        ]
    }

    func loadData(
        withTypeIdentifier typeIdentifier: String,
        forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void
    ) -> Progress? {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                completionHandler(try self.shortcut.build(), nil)
            } catch {
                completionHandler(nil, error)
            }
        }
        return nil
    }
}
