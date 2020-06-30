protocol ActionDecomposable {
    func decompose() -> [Action]
}

extension Shortcut {
    func decompose() -> [Action] {
        if Body.self != Never.self {
            let body = self.body
            if let component = body as? Action {
                return [component]
            } else if let decomposable = body as? ActionDecomposable {
                return decomposable.decompose()
            } else {
                return body.decompose()
            }
        }

        if let decomposable = self as? ActionDecomposable {
            return decomposable.decompose()
        }

        fatalError("Shortcut \(self) has Body = Never but does not conform to ActionDecomposable")
    }
}

extension Action: ActionDecomposable {
    func decompose() -> [Action] {
        [self]
    }
}

extension AnyShortcut: ActionDecomposable {
    func decompose() -> [Action] {
        if let storage = storage as? AnyShortcutStorage<Action> {
            return [storage.action]
        }

        let mirror = Mirror(reflecting: storage)
        let storedValue = mirror.children[mirror.children.startIndex].value

        guard let component = storedValue as? Action else {
            return actionComponents(from: storedValue) ?? []
        }

        return [component]
    }
}

extension _ConditionalContent: ActionDecomposable {
    func decompose() -> [Action] {
        switch storage {
        case .trueContent(let content):
            return content.decompose()
        case .falseContent(let content):
            return content.decompose()
        }
    }
}

extension EmptyShortcut: ActionDecomposable {
    func decompose() -> [Action] {
        []
    }
}

extension ForEach: ActionDecomposable {
    func decompose() -> [Action] {
        children.flatMap { $0.decompose() }
    }
}

extension Optional: ActionDecomposable where Wrapped: Shortcut {
    func decompose() -> [Action] {
        switch self {
        case .some(let value):
            return value.decompose()
        case .none:
            return []
        }
    }
}

extension TupleShortcut: ActionDecomposable {
    func decompose() -> [Action] {
        let mirror = Mirror(reflecting: value)
        return mirror.children.flatMap { _, value in AnyShortcut(_fromValue: value)!.decompose() }
    }
}
