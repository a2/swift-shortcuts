import Foundation
import SwiftShortcuts

struct BatteryLevelWithResultShortcut: Shortcut {
    let makeUUID: () -> UUID

    init(makeUUID: @escaping () -> UUID = UUID.init) {
        self.makeUUID = makeUUID
    }

    var body: some Shortcut {
        ShortcutGroup {
            Comment("This Shortcut was generated in Swift.")
            BatteryLevel().usingResult(uuid: makeUUID()) { batteryLevel in
                If(batteryLevel < Number(20), groupingIdentifier: makeUUID()) {
                    SetLowPowerMode(true)
                    ShowResult("Your battery level is low. Turning on Low Power Mode...")
                }
            }
        }
    }
}
