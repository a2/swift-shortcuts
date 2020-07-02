import Foundation
import SwiftShortcuts

struct ClapAlongShortcut: Shortcut {
    let makeUUID: () -> UUID

    init(makeUUID: @escaping () -> UUID = UUID.init) {
        self.makeUUID = makeUUID
    }

    var body: some Shortcut {
        ShortcutGroup {
            Comment("This Shortcut was generated in Swift.")
            AskForInput(prompt: "WHAT 👏 DO 👏 YOU 👏 WANT 👏 TO 👏 SAY")
                .usingResult(uuid: makeUUID()) { providedInput in
                    ChangeCase(variable: providedInput, target: .value(.uppercase))
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
