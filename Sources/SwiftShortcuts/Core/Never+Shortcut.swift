extension Never: Shortcut {
    public typealias Body = Never
    public var body: Never {
        switch self {}
    }
}
