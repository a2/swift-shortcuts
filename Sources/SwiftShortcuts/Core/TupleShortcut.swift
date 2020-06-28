public struct TupleShortcut<T>: Shortcut {
    public typealias Body = Never
    public var body: Never { fatalError() }

    public var value: T

    init(_ value: T) {
        self.value = value
    }
}
