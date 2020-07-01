import Foundation
import SwiftShortcuts

struct RepeatWithCalculationResultShortcut: Shortcut {
    let makeUUID: () -> UUID

    init(makeUUID: @escaping () -> UUID = UUID.init) {
        self._calculationResult = OutputVariable(wrappedValue: Variable(uuid: makeUUID()))
        self.makeUUID = makeUUID
    }

    @OutputVariable var calculationResult: Variable

    var body: some Shortcut {
        ShortcutGroup {
            Repeat(count: 5, groupingIdentifier: makeUUID()) { index in
                Calculate(calculationResult + index)
                    .savingOutput(to: $calculationResult)
            }.usingResult(uuid: makeUUID()) { results in
                Repeat(iterating: results, groupingIdentifier: makeUUID()) { index, item in
                    Calculate(index * item)
                }
            }
        }
    }
}
