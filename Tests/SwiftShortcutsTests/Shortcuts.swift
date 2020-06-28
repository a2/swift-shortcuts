import SwiftShortcuts

struct BatteryLevelShortcut: Shortcut {
    @OutputVariable var batteryLevel: Variable

    var body: some Shortcut {
        ShortcutGroup {
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
    var body: some Shortcut {
        ShortcutGroup {
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

struct ClapAlongShortcut: Shortcut {
    var body: some Shortcut {
        ShortcutGroup {
            Comment("This Shortcut was generated in Swift.")
            Ask(prompt: "WHAT 👏 DO 👏 YOU 👏 WANT 👏 TO 👏 SAY")
                .usingResult { providedInput in ChangeCase(variable: providedInput, target: .caseType(.uppercase)) }
                .usingResult { changedCaseText in ReplaceText(variable: changedCaseText, target: "[\\s]", replacement: " 👏 ", isRegularExpression: true) }
                .usingResult { updatedText in
                    ChooseFromMenu(items: [
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
    @OutputVariable var calculationResult: Variable

    var body: some Shortcut {
        ShortcutGroup {
            Repeat(count: 5) { index in
                Calculate(calculationResult + index)
                    .savingOutput(to: $calculationResult)
            }.usingResult { results in
                Repeat(iterating: results) { index, item in
                    Calculate(index * item)
                }
            }
        }
    }
}
