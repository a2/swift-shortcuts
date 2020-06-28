public struct ShortcutGroup: Shortcut {
    let content: AnyShortcut

    public var body: some Shortcut { content }

    public init<Content>(@ShortcutBuilder builder: () -> Content) where Content: Shortcut {
        self.content = AnyShortcut(builder())
    }
}
