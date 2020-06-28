extension Shortcut {
    public func usingResult<Content>(@ShortcutBuilder in builder: (Variable) -> Content) -> ResultShortcut<Self, Content> where Content: Shortcut {
        ResultShortcut(base: self, builder: builder)
    }
}

public struct ResultShortcut<Base, Content>: Shortcut where Base: Shortcut {
    let base: SavedOutputShortcut<Base>
    let content: Content

    public var body: some Shortcut {
        TupleShortcut((base, content))
    }

    public init(base: Base, @ShortcutBuilder builder: (Variable) -> Content) {
        let variable = Variable()
        self.base = SavedOutputShortcut(base: base, variable: variable)
        self.content = builder(variable)
    }
}
