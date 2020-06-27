extension Optional: Action where Wrapped: Action {
    public typealias Body = Never
    public var body: Never { fatalError() }
}
