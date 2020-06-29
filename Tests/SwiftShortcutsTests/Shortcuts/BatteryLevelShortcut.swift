import Foundation
import SwiftShortcuts

struct BatteryLevelShortcut: Shortcut {
    let makeUUID: () -> UUID

    init(makeUUID: @escaping () -> UUID = UUID.init) {
        self.makeUUID = makeUUID
        self._batteryLevel = OutputVariable(wrappedValue: Variable(uuid: makeUUID()))
    }

    @OutputVariable var batteryLevel

    var body: some Shortcut {
        ShortcutGroup {
            Comment("This Shortcut was generated in Swift.")
            BatteryLevel()
                .savingOutput(to: $batteryLevel)
            If(batteryLevel < Number(20), groupingIdentifier: makeUUID()) {
                SetLowPowerMode(true)
                ShowResult("Your battery level is \(batteryLevel)%; you might want to charge soon.")
            } else: {
                ShowResult("Your battery level is \(batteryLevel)%; you're probably fine for now.")
            }
        }
    }
}
