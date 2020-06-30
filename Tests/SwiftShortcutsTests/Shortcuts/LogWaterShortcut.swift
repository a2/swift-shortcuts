import Foundation
import SwiftShortcuts

struct LogWaterShortcut: Shortcut {
    let makeUUID: () -> UUID

    init(makeUUID: @escaping () -> UUID = UUID.init) {
        self.makeUUID = makeUUID
    }

    var body: some Shortcut {
        ShortcutGroup {
            List("0.3", "0.5", "0.7", "1", "1.5")
                .usingResult(uuid: makeUUID()) { liters in ChooseFromList(input: liters, prompt: "How many liters of water did you drink?") }
                .usingResult(uuid: makeUUID()) { choice in LogHealthSample(type: .water, value: HealthSampleValue(magnitude: choice, unit: .liters)) }
        }
    }
}
