public struct ActionGroup: Action {
    let content: AnyAction

    public var body: some Action { content }

    public init<Content>(@ActionBuilder builder: () -> Content) where Content: Action {
        self.content = AnyAction(builder())
    }
}
