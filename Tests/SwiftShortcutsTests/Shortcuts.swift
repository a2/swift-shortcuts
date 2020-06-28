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

struct ClapAlongShortcut: Shortcut {
    let makeUUID: () -> UUID

    init(makeUUID: @escaping () -> UUID = UUID.init) {
        self.makeUUID = makeUUID
    }

    var body: some Shortcut {
        ShortcutGroup {
            Comment("This Shortcut was generated in Swift.")
            Ask(prompt: "WHAT 👏 DO 👏 YOU 👏 WANT 👏 TO 👏 SAY")
                .usingResult(uuid: makeUUID()) { providedInput in
                    ChangeCase(variable: providedInput, target: .caseType(.uppercase))
                }
                .usingResult(uuid: makeUUID()) { changedCaseText in
                    ReplaceText(variable: changedCaseText, target: "[\\s]", replacement: " 👏 ", isRegularExpression: true)
                }
                .usingResult(uuid: makeUUID()) { updatedText in
                    ChooseFromMenu(groupingIdentifier: makeUUID(), items: [
                        MenuItem(label: "Share") {
                            Share(input: updatedText)
                        },
                        MenuItem(label: "Copy to Clipboard") {
                            CopyToClipboard(content: updatedText)
                        },
                    ])
                }
        }
    }
}

struct RepeatWithCalculationResultShortcut: Shortcut {
    let makeUUID: () -> UUID

    init(makeUUID: @escaping () -> UUID = UUID.init) {
        self._calculationResult = OutputVariable(wrappedValue: Variable(uuid: makeUUID()))
        self.makeUUID = makeUUID
    }

    @OutputVariable var calculationResult

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
