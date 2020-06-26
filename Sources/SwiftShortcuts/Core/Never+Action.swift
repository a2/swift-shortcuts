extension Never: Action {
    public typealias Body = Never

    public var body: Never {
        switch self {}
    }
}
