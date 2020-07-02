import Foundation

extension Shortcut {
    /// Passes the output of this shortcut as a variable that can be referenced in other shortcuts.
    /// - Parameters:
    ///   - name: An optional name to use for the new variable.
    ///   - uuid: An optional UUID to use for the new variable. Useful for building deterministic output.
    ///   - builder: A closure that is passed the result of the modified shortcut.
    /// - Returns: A modified shortcut that passes its result to the `builder` closure.
    public func usingResult<Content>(named name: String? = nil, uuid: UUID = UUID(), @ShortcutBuilder in builder: (Variable) -> Content) -> ResultShortcut<Self, Content> where Content: Shortcut {
        ResultShortcut(base: self, variableName: name, variableUUID: uuid, builder: builder)
    }
}

/// A shortcut that wraps another shortcut, passing its result to a closure for reference.
public struct ResultShortcut<Base, Content>: Shortcut where Base: Shortcut {
    let base: SavedOutputShortcut<Base>
    let content: Content

    /// The contents of the shortcut.
    public var body: some Shortcut {
        TupleShortcut((base, content))
    }

    /// - Parameters:
    ///   - base: The base shortcut whose result to pass into the `builder` closure.
    ///   - name: An optional name to use for the new variable.
    ///   - uuid: An optional UUID to use for the new variable. Useful for building deterministic output.
    ///   - builder: A closure that is passed the result of the modified shortcut.
    public init(base: Base, variableName name: String? = nil, variableUUID uuid: UUID, @ShortcutBuilder builder: (Variable) -> Content) {
        let variable = Variable(name: name, uuid: uuid)
        self.base = SavedOutputShortcut(base: base, variable: variable)
        self.content = builder(variable)
    }
}
