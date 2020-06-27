protocol Decomposable {
    func decompose() -> [ActionStep]
}

extension Action {
    func decompose() -> [ActionStep] {
        if Body.self != Never.self {
            let body = self.body
            if let actionStep = body as? ActionStep {
                return [actionStep]
            } else if let decomposable = body as? Decomposable {
                return decomposable.decompose()
            }
        }

        if let decomposable = self as? Decomposable {
            return decomposable.decompose()
        }

        fatalError()
    }
}

extension ActionStep: Decomposable {
    func decompose() -> [ActionStep] {
        [self]
    }
}

extension AnyAction: Decomposable {
    func decompose() -> [ActionStep] {
        if let storage = storage as? AnyActionStorage<ActionStep> {
            return [storage.action]
        }

        let mirror = Mirror(reflecting: self)
        let storage = mirror.children[mirror.children.startIndex].value
        let storageMirror = Mirror(reflecting: storage)
        let storedValue = storageMirror.children[storageMirror.children.startIndex].value

        guard let actionStep = storedValue as? ActionStep else {
            return actionSteps(from: storedValue) ?? []
        }

        return [actionStep]
    }
}

extension EmptyAction: Decomposable {
    func decompose() -> [ActionStep] {
        []
    }
}

extension ForEach: Decomposable {
    func decompose() -> [ActionStep] {
        children.flatMap { $0.decompose() }
    }
}

extension Optional: Decomposable where Wrapped: Action {
    func decompose() -> [ActionStep] {
        switch self {
        case .some(let value):
            return value.decompose()
        case .none:
            return []
        }
    }
}

extension TupleAction: Decomposable {
    func decompose() -> [ActionStep] {
        let mirror = Mirror(reflecting: self)
        let value = mirror.children[mirror.children.startIndex].value
        let valueMirror = Mirror(reflecting: value)
        return valueMirror.children.flatMap { _, value in AnyAction(_fromValue: value)!.decompose() }
    }
}
