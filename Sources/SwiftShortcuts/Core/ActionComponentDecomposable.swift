protocol ActionComponentDecomposable {
    func decompose() -> [ActionComponent]
}

extension Action {
    func decompose() -> [ActionComponent] {
        if Body.self != Never.self {
            let body = self.body
            if let component = body as? ActionComponent {
                return [component]
            } else if let decomposable = body as? ActionComponentDecomposable {
                return decomposable.decompose()
            } else {
                return body.decompose()
            }
        }

        if let decomposable = self as? ActionComponentDecomposable {
            return decomposable.decompose()
        }

        fatalError("Action \(self) has Body = Never but does not conform to ActionComponentDecomposable")
    }
}

extension ActionComponent: ActionComponentDecomposable {
    func decompose() -> [ActionComponent] {
        [self]
    }
}

extension AnyAction: ActionComponentDecomposable {
    func decompose() -> [ActionComponent] {
        if let storage = storage as? AnyActionStorage<ActionComponent> {
            return [storage.action]
        }

        let mirror = Mirror(reflecting: storage)
        let storedValue = mirror.children[mirror.children.startIndex].value

        guard let component = storedValue as? ActionComponent else {
            return actionComponents(from: storedValue) ?? []
        }

        return [component]
    }
}

extension EmptyAction: ActionComponentDecomposable {
    func decompose() -> [ActionComponent] {
        []
    }
}

extension ForEach: ActionComponentDecomposable {
    func decompose() -> [ActionComponent] {
        children.flatMap { $0.decompose() }
    }
}

extension Optional: ActionComponentDecomposable where Wrapped: Action {
    func decompose() -> [ActionComponent] {
        switch self {
        case .some(let value):
            return value.decompose()
        case .none:
            return []
        }
    }
}

extension TupleAction: ActionComponentDecomposable {
    func decompose() -> [ActionComponent] {
        let mirror = Mirror(reflecting: value)
        return mirror.children.flatMap { _, value in AnyAction(_fromValue: value)!.decompose() }
    }
}
