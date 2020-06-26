import SwiftShortcuts
import XCTest

final class SwiftShortcutsTests: XCTestCase {
    func testExample() throws {
        let shortcut = BatteryLevelShortcut()
        _ = try shortcut.build()
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}


import Foundation

struct BatteryLevelShortcut: Shortcut {
    @ActionBuilder var body: some Action {
        Comment("A")
        Comment("B")
    }
}
