public struct Nothing: Shortcut {
    public var body: some Shortcut {
        Action(identifier: "is.workflow.actions.nothing")
    }

    public init() {}
}
