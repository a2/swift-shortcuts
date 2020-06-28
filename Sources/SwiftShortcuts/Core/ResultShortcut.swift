import Foundation

extension Shortcut {
    public func usingResult<Content>(named name: String? = nil, uuid: UUID = UUID(), @ShortcutBuilder in builder: (Variable) -> Content) -> ResultShortcut<Self, Content> where Content: Shortcut {
        ResultShortcut(base: self, variableName: name, variableUUID: uuid, builder: builder)
    }
}

public struct ResultShortcut<Base, Content>: Shortcut where Base: Shortcut {
    let base: SavedOutputShortcut<Base>
    let content: Content

    public var body: some Shortcut {
        TupleShortcut((base, content))
    }

    public init(base: Base, variableName name: String? = nil, variableUUID uuid: UUID, @ShortcutBuilder builder: (Variable) -> Content) {
        let variable = Variable(name: name, uuid: uuid)
        self.base = SavedOutputShortcut(base: base, variable: variable)
        self.content = builder(variable)
    }
}
