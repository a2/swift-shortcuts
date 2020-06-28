public struct EmptyShortcut: Shortcut {
    public typealias Body = Never
    public var body: Never { fatalError() }

    public init() {}
}
