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
    @OutputVariable var updatedText

    @ActionBuilder var body: some Action {
        Comment("This Shortcut was generated in Swift.")
        Ask(prompt: "WHAT 👏 DO 👏 YOU 👏 WANT 👏 TO 👏 SAY")
//        ChangeCase(variable: .lastResult, target: .caseType(.uppercase))
//        ReplaceText(variable: .lastResult, target: "[\\s]", replacement: " 👏 ", isRegularExpression: true)
//            .savingOutput(to: $updatedText)

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
