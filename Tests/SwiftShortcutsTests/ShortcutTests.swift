import SnapshotTesting
import XCTest
@testable import SwiftShortcuts

final class ShortcutTests: XCTestCase {
    func testBatteryLevelShortcut() {
        let shortcut = BatteryLevelShortcut(makeUUID: UUID.incrementing)
        assertSnapshot(matching: shortcut, as: .shortcut)
    }

    func testBatteryLevelWithResultShortcut() {
        let shortcut = BatteryLevelWithResultShortcut(makeUUID: UUID.incrementing)
        assertSnapshot(matching: shortcut, as: .shortcut)
    }

    func testClapAlongShortcut() {
        let shortcut = ClapAlongShortcut(makeUUID: UUID.incrementing)
        assertSnapshot(matching: shortcut, as: .shortcut)
    }

    func testDictionaryShortcut() {
        let shortcut = DictionaryShortcut(makeUUID: UUID.incrementing)
        assertSnapshot(matching: shortcut, as: .shortcut)
    }

    func testLogWaterShortcut() {
        let shortcut = LogWaterShortcut(makeUUID: UUID.incrementing)
        assertSnapshot(matching: shortcut, as: .shortcut)
    }

    func testRepeatWithCalculationResultShortcut() {
        let shortcut = RepeatWithCalculationResultShortcut(makeUUID: UUID.incrementing)
        assertSnapshot(matching: shortcut, as: .shortcut)
    }

    func testShortenWithSmallCatShortcut() {
        let shortcut = ShortenWithSmallCatShortcut(makeUUID: UUID.incrementing)
        assertSnapshot(matching: shortcut, as: .shortcut)
    }

    static var allTests = [
        ("testBatteryLevelShortcut", testBatteryLevelShortcut),
        ("testBatteryLevelWithResultShortcut", testBatteryLevelWithResultShortcut),
        ("testClapAlongShortcut", testClapAlongShortcut),
        ("testDictionaryShortcut", testDictionaryShortcut),
        ("testLogWaterShortcut", testLogWaterShortcut),
        ("testRepeatWithCalculationResultShortcut", testRepeatWithCalculationResultShortcut),
        ("testShortenWithSmallCatShortcut", testShortenWithSmallCatShortcut),
    ]
}
