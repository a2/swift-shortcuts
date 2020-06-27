extension Action {
    public func usingResult<Content>(@ActionBuilder in builder: (Variable) -> Content) -> ResultAction<Self, Content> where Content: Action {
        ResultAction(base: self, builder: builder)
    }
}

public struct ResultAction<Base, Content>: Action where Base: Action {
    let base: SavedOutputAction<Base>
    let content: Content

    public var body: some Action {
        TupleAction((base, content))
    }

    public init(base: Base, @ActionBuilder builder: (Variable) -> Content) {
        let variable = Variable()
        self.base = SavedOutputAction(base: base, variable: variable)
        self.content = builder(variable)
    }
}
