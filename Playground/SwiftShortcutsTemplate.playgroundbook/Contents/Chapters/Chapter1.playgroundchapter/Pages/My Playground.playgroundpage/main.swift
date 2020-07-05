import SwiftShortcuts
import ShortcutSupport
import PlaygroundSupport

struct HelloWorldShortcut: Shortcut {
    var body: some Shortcut {
        Comment("Hello, world!")
    }
}

let shortcut = HelloWorldShortcut()

PlaygroundPage.current.show(shortcut)
