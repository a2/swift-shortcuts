import SnapshotTesting
import XCTest
@testable import SwiftShortcuts

final class ShortcutTests: XCTestCase {
    func testBatteryLevelShortcut() throws {
        let shortcut = BatteryLevelShortcut(makeUUID: UUID.incrementing)
        assertSnapshot(matching: shortcut, as: .shortcut)
    }

    func testBatteryLevelWithResultShortcut() throws {
        let shortcut = BatteryLevelWithResultShortcut(makeUUID: UUID.incrementing)
        assertSnapshot(matching: shortcut, as: .shortcut)
    }

    func testClapAlongShortcut() throws {
        let shortcut = ClapAlongShortcut(makeUUID: UUID.incrementing)
        assertSnapshot(matching: shortcut, as: .shortcut)
    }

    func testRepeatWithCalculationResultShortcut() throws {
        let shortcut = RepeatWithCalculationResultShortcut(makeUUID: UUID.incrementing)
        assertSnapshot(matching: shortcut, as: .shortcut)
    }

    func testShortenWithSmallCatShortcut() throws {
        let shortcut = ShortenWithSmallCatShortcut(makeUUID: UUID.incrementing)
        assertSnapshot(matching: shortcut, as: .shortcut)
    }

    static var allTests = [
        ("testBatteryLevelShortcut", testBatteryLevelShortcut),
        ("testBatteryLevelWithResultShortcut", testBatteryLevelWithResultShortcut),
        ("testClapAlongShortcut", testClapAlongShortcut),
        ("testRepeatWithCalculationResultShortcut", testRepeatWithCalculationResultShortcut),
        ("testShortenWithSmallCatShortcut", testShortenWithSmallCatShortcut),
    ]
}
