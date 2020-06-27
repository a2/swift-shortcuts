protocol Decomposable {
    func decompose() -> [ActionComponent]
}

extension Action {
    func decompose() -> [ActionComponent] {
        if Body.self != Never.self {
            let body = self.body
            if let component = body as? ActionComponent {
                return [component]
            } else if let decomposable = body as? Decomposable {
                return decomposable.decompose()
            }
        }

        if let decomposable = self as? Decomposable {
            return decomposable.decompose()
        }

        fatalError("Action \(self) has Body = Never but is not Decomposable")
    }
}

extension ActionComponent: Decomposable {
    func decompose() -> [ActionComponent] {
        [self]
    }
}

extension AnyAction: Decomposable {
    func decompose() -> [ActionComponent] {
        if let storage = storage as? AnyActionStorage<ActionComponent> {
            return [storage.action]
        }

        let mirror = Mirror(reflecting: self)
        let storage = mirror.children[mirror.children.startIndex].value
        let storageMirror = Mirror(reflecting: storage)
        let storedValue = storageMirror.children[storageMirror.children.startIndex].value

        guard let component = storedValue as? ActionComponent else {
            return actionComponents(from: storedValue) ?? []
        }

        return [component]
    }
}

extension EmptyAction: Decomposable {
    func decompose() -> [ActionComponent] {
        []
    }
}

extension ForEach: Decomposable {
    func decompose() -> [ActionComponent] {
        children.flatMap { $0.decompose() }
    }
}

extension Optional: Decomposable where Wrapped: Action {
    func decompose() -> [ActionComponent] {
        switch self {
        case .some(let value):
            return value.decompose()
        case .none:
            return []
        }
    }
}

extension TupleAction: Decomposable {
    func decompose() -> [ActionComponent] {
        let mirror = Mirror(reflecting: self)
        let value = mirror.children[mirror.children.startIndex].value
        let valueMirror = Mirror(reflecting: value)
        return valueMirror.children.flatMap { _, value in AnyAction(_fromValue: value)!.decompose() }
    }
}
