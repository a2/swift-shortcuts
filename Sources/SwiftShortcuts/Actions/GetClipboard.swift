/// Returns the contents of the clipboard.
///
/// **Result:** Anything
public struct GetClipboard: Shortcut {
    /// The contents of the shortcut.
    public var body: some Shortcut {
        Action(identifier: "is.workflow.actions.getclipboard")
    }

    /// Initializes the shortcut.
    public init() {}
}
