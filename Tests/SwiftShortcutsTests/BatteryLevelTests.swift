import SwiftShortcuts
import XCTest

final class BatteryLevelTests: XCTestCase {
    func testBuild() throws {
        let shortcut = BatteryLevelShortcut()
        let data = try shortcut.build()

        var format: PropertyListSerialization.PropertyListFormat = .binary
        let reconstructed = try PropertyListSerialization.propertyList(from: data, format: &format)

        XCTAssertEqual(format, .binary)
        print(reconstructed as? NSDictionary ?? [:])
    }

    func testBuildWithResult() throws {
        let shortcut = BatteryLevelWithResultShortcut()
        let data = try shortcut.build()

        var format: PropertyListSerialization.PropertyListFormat = .binary
        let reconstructed = try PropertyListSerialization.propertyList(from: data, format: &format)

        XCTAssertEqual(format, .binary)
        print(reconstructed as? NSDictionary ?? [:])
    }

    static var allTests = [
        ("testBuild", testBuild),
        ("testBuildWithResult", testBuildWithResult),
    ]
}

struct BatteryLevelShortcut: Shortcut {
    @OutputVariable var batteryLevel: Variable

    var body: some Action {
        ActionGroup {
            Comment("This Shortcut was generated in Swift.")
            BatteryLevel()
                .savingOutput(to: $batteryLevel)
            If(batteryLevel < 20, then: {
                SetLowPowerMode(true)
                ShowResult("Your battery level is \(batteryLevel)%; you might want to charge soon.")
            }, else: {
                ShowResult("Your battery level is \(batteryLevel)%; you're probably fine for now.")
            })
        }
    }
}

struct BatteryLevelWithResultShortcut: Shortcut {
    var body: some Action {
        ActionGroup {
            Comment("This Shortcut was generated in Swift.")
            BatteryLevel().usingResult { batteryLevel in
                If(batteryLevel < 20) {
                    SetLowPowerMode(true)
                    ShowResult("Your battery level is low. Turning on Low Power Mode...")
                }
            }
        }
    }
}
