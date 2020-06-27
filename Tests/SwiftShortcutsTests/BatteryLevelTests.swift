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

    func testBuildWithLastResult() throws {
        let shortcut = BatteryLevelWithLastResultShortcut()
        let data = try shortcut.build()

        var format: PropertyListSerialization.PropertyListFormat = .binary
        let reconstructed = try PropertyListSerialization.propertyList(from: data, format: &format)

        XCTAssertEqual(format, .binary)
        print(reconstructed as? NSDictionary ?? [:])
    }

    static var allTests = [
        ("testBuild", testBuild),
        ("testBuildWithLastResult", testBuildWithLastResult),
    ]
}

struct BatteryLevelShortcut: Shortcut {
    @OutputVariable var batteryLevel

    @ActionBuilder var body: some Action {
        Comment("This Shortcut was generated in Swift.")
        BatteryLevel()
            .savingOutput(to: $batteryLevel)
        If(batteryLevel < 20) {
            SetLowPowerMode(true)
            ShowResult("Your battery level is \(batteryLevel)%; you might want to charge soon.")
        } else: {
            ShowResult("Your battery level is \(batteryLevel)%; you're probably fine for now.")
        }
    }
}

struct BatteryLevelWithLastResultShortcut: Shortcut {
    @ActionBuilder var body: some Action {
        Comment("This Shortcut was generated in Swift.")
        BatteryLevel()
        If(.lastResult < 20) {
            SetLowPowerMode(true)
            ShowResult("Your battery level is low. Turning on Low Power Mode...")
        }
    }
}

struct BatteryLevelWithLastResultShortcut2: Shortcut {
    @ActionBuilder var body: some Action {
        Comment("This Shortcut was generated in Swift.")
        BatteryLevel().withResult { lastResult in
            If(lastResult < 20) {
                SetLowPowerMode(true)
                ShowResult("Your battery level is low. Turning on Low Power Mode...")
            }
        }
    }
}

struct BatteryLevelWithLastResultShortcut3: Shortcut {
    @ActionBuilder var body: some Action {
        Comment("This Shortcut was generated in Swift.")
        ResultReader { variable in
            BatteryLevel()
                .savingOutput(to: variable)
            If(variable < 20) {
                SetLowPowerMode(true)
                ShowResult("Your battery level is low. Turning on Low Power Mode...")
            }
        }
    }
}
