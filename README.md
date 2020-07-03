# SwiftShortcuts

An iOS 14 Shortcuts creator written in Swift, inspired by SwiftUI.

## Installation

SwiftShortcuts is distributed using the [Swift Package Manager](https://swift.org/package-manager/). To install it into a project, add it as a dependency within your `Package.swift` manifest:

```swift
let package = Package(
    ...
    dependencies: [
        .package(url: "https://github.com/a2/swift-shortcuts.git", from: "0.1.0")
    ],
    ...
)
```

Then import SwiftShortcuts in your project wherever you'd like to use it:

```swift
import SwiftShortcuts
```

## Getting Started

SwiftShorcuts was inspired by SwiftUI and, just as every SwiftUI `View` is made from other `View` types, so too is every `Shortcut` built from other `Shortcut` types. The only requirement of the `Shortcut` protocol is an instance property named `body` whose type is another `Shortcut`:

```swift
/// A type that represents a user workflow, or a part of one, in the Shortcuts app.
public protocol Shortcut {
    /// The type of shortcut representing the body of this shortcut.
    ///
    /// When you create a custom shortcut, Swift infers this type from your
    /// implementation of the required `body` property.
    associatedtype Body: Shortcut

    /// The contents of the shortcut.
    var body: Body { get }
}
```

To start writing your own shortcut, create a type (such as a `struct`) that conforms to the Shortcut protocol. At first, return a `Comment` with some "Hello, world!" text.

```swift
// main.swift

struct HelloWorldShortcut: Shortcut {
    var body: some Shortcut {
        Comment("Hello, world!")
    }
}
```

To create a file that you can import into the Shortcuts app, call the `build()` function on your shortcut and write the `Data` to a file.

```swift
// continued from above

let shortcut = HelloWorldShortcut()
let data = try shortcut.build()
try data.write(to: URL(fileURLWithPath: "Hello World.shortcut"))
```

Now you can share (for example, via AirDrop) the _Hello World.shortcut_ file to your device and it will open in the Shortcuts app. Unfortunately iOS 13 does not support opening serialized `.shortcut` files.

## Examples

### Warn for Low Battery Level

Saves the output of `BatteryLevel` shortcut to an `OutputVariable` and later references that value in a `ShowResult` shortcut.

```swift
// Swift 5.2
import SwiftShortcuts

struct BatteryLevelShortcut: Shortcut {
    @OutputVariable var batteryLevel: Variable

    var body: some Shortcut {
        ShortcutGroup {
            Comment("This Shortcut was generated in Swift.")
            BatteryLevel()
                .savingOutput(to: $batteryLevel)
            If(batteryLevel < Number(20), then: {
                SetLowPowerMode(true)
                ShowResult("Your battery level is \(batteryLevel)%; you might want to charge soon.")
            }, else: {
                ShowResult("Your battery level is \(batteryLevel)%; you're probably fine for now.")
            })
        }
    }
}
```

### Clap Along

Takes advantage of the `usingResult()` function to chain shortcut outputs to shortcut inputs.

```swift
// Swift 5.2
import SwiftShortcuts

struct ClapAlongShortcut: Shortcut {
    var body: some Shortcut {
        ShortcutGroup {
            Comment("This Shortcut was generated in Swift.")
            AskForInput(prompt: "WHAT 👏 DO 👏 YOU 👏 WANT 👏 TO 👏 SAY")
                .usingResult { providedInput in
                    ChangeCase(variable: providedInput, target: .value(.uppercase))
                }
                .usingResult { changedCaseText in
                    ReplaceText(variable: changedCaseText, target: "[\\s]", replacement: " 👏 ", isRegularExpression: true)
                }
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
```

### Shorten with [small.cat](https://small.cat)

A more complicated example that temporarily shortens a URL or some text with the small.cat service.

```swift
// Swift 5.2
import SwiftShortcuts

struct ShortenWithSmallCatShortcut: Shortcut {
    @OutputVariable var url: Variable
    @OutputVariable var expiry: Variable

    var body: some Shortcut {
        ShortcutGroup {
            GetType(input: .shortcutInput)
                .usingResult { type in
                    If(type == "URL", then: {
                        Text("\(.shortcutInput)")
                    }, else: {
                        GetClipboard()
                    })
                }
                .usingResult { ifResult in
                    URLEncode(input: "\(ifResult)")
                }
                .savingOutput(to: $url)

            ChooseFromMenu(prompt: "Expires in:", items: [
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
            ])).usingResult { contents in
                GetURLsFromInput(input: "\(contents)")
            }.usingResult { urls in
                FilterFiles(input: urls, filters: .all([
                    NameFilter(beginsWith: "http://small.cat/"),
                    NameFilter(isNot: "http://small.cat/"),
                ]), limit: 1)
            }.usingResult { url in
                ChooseFromMenu(items: [
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
```

## Design and Goals

SwiftShortcuts began as the similarly named [ShortcutsSwift](https://github.com/a2/shortcuts-swift) and was originally inspired by [Shortcuts JS](https://github.com/joshfarrant/shortcuts-js). Both SwiftShortcuts, and ShortcutsSwift before it, aimed to be in Swift what Shortcuts JS is for JavaScript.

The goal of this iteration of SwiftShortcuts is to make writing Shortcuts app workflows in Swift as easy as composing `View`s in SwiftUI. As you can see [above](#getting-started), even the base `Shortcut` protocol is heavily inspired by SwiftUI's `View` protocol.

This repository does not contain every possible Shortcuts-supported action or every possible permutation of parametres for those shortcuts. Please feel free to [contribute](#contributions-and-support) missing shortcut types and even test cases.

## License

SwiftShortcuts is available under the MIT license. See the [LICENSE](LICENSE) file for more info.

## Contributions and Support

*Inspired by the support model behind [Publish](https://github.com/JohnSundell/Publish).*

SwiftShortcuts is developed completely in the open, and your contributions are more than welcome.

This project does not come with GitHub Issues-based support, and users are instead encouraged to become active participants in its continued development — by fixing any bugs that they encounter, or by improving the documentation wherever it's found to be lacking.

If you wish to make a change, [open a Pull Request](https://github.com/a2/swift-shortcuts/pull/new) — even if it just contains a draft of the changes you're planning, or a test that reproduces an issue — and we can discuss it further from there.

Hope you'll enjoy using SwiftShortcuts!
