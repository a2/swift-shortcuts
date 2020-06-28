extension Optional: Shortcut where Wrapped: Shortcut {
    public typealias Body = Never
    public var body: Never { fatalError() }
}
