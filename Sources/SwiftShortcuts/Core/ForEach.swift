/// A structure that computes shortcuts from an underlying collection of data.
public struct ForEach: Shortcut {
    let children: [AnyShortcut]

    public typealias Body = Never
    public var body: Never { fatalError() }

    /// Initializes the shortcut.
    /// - Parameter data: A collection of shortcuts.
    public init<Data>(_ data: Data) where Data: Collection, Data.Element: Shortcut {
        self.children = data.map(AnyShortcut.init)
    }

    /// Initializes the shortcut.
    /// - Parameters:
    ///   - data: The data that the `ForEach` value uses to create shortcuts.
    ///   - content: The shortcut builder that creates shortcuts.
    public init<Data, Content>(_ data: Data, @ShortcutBuilder content: (Data.Element) -> Content) where Data: Collection, Content: Shortcut {
        self.children = data.map { item in AnyShortcut(content(item)) }
    }
}
