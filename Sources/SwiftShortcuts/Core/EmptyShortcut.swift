/// An empty shortcut that has no actions.
public struct EmptyShortcut: Shortcut {
    public typealias Body = Never
    public var body: Never { fatalError() }

    /// Initializes an empty shortcut.
    public init() {}
}
