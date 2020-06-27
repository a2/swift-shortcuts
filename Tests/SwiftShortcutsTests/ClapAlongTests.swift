import SwiftShortcuts
import XCTest

final class ClapAlongTests: XCTestCase {
    func testBuild() throws {
        let shortcut = ClapAlongShortcut()
        let data = try shortcut.build()

        var format: PropertyListSerialization.PropertyListFormat = .binary
        let reconstructed = try PropertyListSerialization.propertyList(from: data, format: &format)

        XCTAssertEqual(format, .binary)
        print(reconstructed as? NSDictionary ?? [:])
    }

    static var allTests = [
        ("testBuild", testBuild),
    ]
}

struct ClapAlongShortcut: Shortcut {
    var body: some Action {
        ActionGroup {
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
