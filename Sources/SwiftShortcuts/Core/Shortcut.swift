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
