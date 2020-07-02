/// An affordance for grouping shortcut content.
public struct ShortcutGroup: Shortcut {
    let content: AnyShortcut

    /// The contents of the shortcut.
    public var body: some Shortcut { content }

    /// Initializes the shortcut group with the specified content.
    /// - Parameter content: The shortcut builder that creates shortcuts.
    public init<Content>(@ShortcutBuilder content: () -> Content) where Content: Shortcut {
        self.content = AnyShortcut(content())
    }
}
