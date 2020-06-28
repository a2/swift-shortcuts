import SwiftShortcuts
import XCTest

final class ShortcutTests: XCTestCase {
    func testBatteryLevelShortcut() throws {
        let shortcut = BatteryLevelShortcut()
        let data = try shortcut.build()

        var format: PropertyListSerialization.PropertyListFormat = .binary
        let reconstructed = try PropertyListSerialization.propertyList(from: data, format: &format)

        XCTAssertEqual(format, .binary)
        print(reconstructed as? NSDictionary ?? [:])
    }

    func testBatteryLevelWithResultShortcut() throws {
        let shortcut = BatteryLevelWithResultShortcut()
        let data = try shortcut.build()

        var format: PropertyListSerialization.PropertyListFormat = .binary
        let reconstructed = try PropertyListSerialization.propertyList(from: data, format: &format)

        XCTAssertEqual(format, .binary)
        print(reconstructed as? NSDictionary ?? [:])
    }

    func testClapAlongShortcut() throws {
        let shortcut = ClapAlongShortcut()
        let data = try shortcut.build()

        var format: PropertyListSerialization.PropertyListFormat = .binary
        let reconstructed = try PropertyListSerialization.propertyList(from: data, format: &format)

        XCTAssertEqual(format, .binary)
        print(reconstructed as? NSDictionary ?? [:])
    }

    func testRepeatWithCalculationResultShortcut() throws {
        let shortcut = RepeatWithCalculationResultShortcut()
        let data = try shortcut.build()

        var format: PropertyListSerialization.PropertyListFormat = .binary
        let reconstructed = try PropertyListSerialization.propertyList(from: data, format: &format)

        XCTAssertEqual(format, .binary)
        print(reconstructed as? NSDictionary ?? [:])
    }

    static var allTests = [
        ("testBatteryLevelShortcut", testBatteryLevelShortcut),
        ("testBatteryLevelWithResultShortcut", testBatteryLevelWithResultShortcut),
        ("testClapAlongShortcut", testClapAlongShortcut),
        ("testRepeatWithCalculationResultShortcut", testRepeatWithCalculationResultShortcut),
    ]
}
