/// A shortcut composed of multiple child shortcuts, expressed as a tuple of those values.
public struct TupleShortcut<T>: Shortcut {
    public typealias Body = Never
    public var body: Never { fatalError() }

    /// A tuple of child shortcuts
    public var value: T

    /// - Parameter value: A tuple of child shortcuts
    init(_ value: T) {
        self.value = value
    }
}
