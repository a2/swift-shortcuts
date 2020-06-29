import Foundation
import SwiftShortcuts

struct ShortenWithSmallCatShortcut: Shortcut {
    let makeUUID: () -> UUID

    init(makeUUID: @escaping () -> UUID = UUID.init) {
        self.makeUUID = makeUUID
        self._url = OutputVariable(wrappedValue: Variable(uuid: makeUUID()))
        self._expiry = OutputVariable(wrappedValue: Variable(uuid: makeUUID()))
    }

    @OutputVariable var url
    @OutputVariable var expiry

    var body: some Shortcut {
        ShortcutGroup {
            GetType(input: .shortcutInput)
                .usingResult(uuid: makeUUID()) { type in
                    If(type == "URL", groupingIdentifier: makeUUID()) {
                        GetVariable(variable: type)
                    } else: {
                        GetClipboard()
                    }
                }
                .usingResult(uuid: makeUUID()) { ifResult in
                    URLEncode(input: "\(ifResult)")
                }
                .savingOutput(to: $url)

            ChooseFromMenu(prompt: "Expires in:", groupingIdentifier: makeUUID(), items: [
                    MenuItem(label: "10 minutes") {
                        Text("10")
                    },
                    MenuItem(label: "1 hour") {
                        Text("60")
                    },
                    MenuItem(label: "1 day") {
                        Text("1440")
                    },
                    MenuItem(label: "1 week") {
                        Text("10080")
                    },
                ])
                .savingOutput(to: $expiry)

            GetContentsOfURL(method: .POST, url: "https://small.cat/entries", body: .form([
                "entry[duration]": "\(expiry)",
                "entry[value]": "\(url)",
                "utf8": "✓",
            ])).usingResult(uuid: makeUUID()) { contents in
                GetURLsFromInput(input: "\(contents)")
            }.usingResult(uuid: makeUUID()) { urls in
                FilterFiles(input: urls, filters: .all([
                    NameFilter(beginsWith: "http://small.cat/"),
                    NameFilter(isNot: "http://small.cat/"),
                ]), limit: 1)
            }.usingResult(uuid: makeUUID()) { url in
                ChooseFromMenu(groupingIdentifier: makeUUID(), items: [
                    MenuItem(label: "Copy") {
                        CopyToClipboard(content: url)
                    },
                    MenuItem(label: "Share") {
                        Share(input: url)
                    },
                    MenuItem(label: "Show") {
                        ShowAlert(title: "Small.cat", message: "\(url)", showsCancelButton: false)
                    },
                ])
            }
        }
    }
}
