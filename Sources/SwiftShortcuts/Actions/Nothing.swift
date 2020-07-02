/// The "Nothing" shortcut. This is different from an `EmptyShortcut` value, which contains no actions.
public struct Nothing: Shortcut {
    /// The contents of the shortcut.
    public var body: some Shortcut {
        Action(identifier: "is.workflow.actions.nothing")
    }

    /// Initializes a "Nothing" shortcut with no arguments.
    public init() {}
}
