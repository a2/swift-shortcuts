protocol Decomposable {
    func decompose() -> [AnyAction]
}

extension ActionStep: Decomposable {
    func decompose() -> [AnyAction] {
        [AnyAction(self)]
    }
}

extension AnyAction: Decomposable {
    func decompose() -> [AnyAction] {
        let mirror = Mirror(reflecting: self)
        let storage = mirror.children[mirror.children.startIndex]
        let storageMirror = Mirror(reflecting: storage)
        guard let action = storageMirror.children[storageMirror.children.startIndex].value as? Decomposable else {
            return [self]
        }

        return action.decompose()
    }
}

extension EmptyAction: Decomposable {
    func decompose() -> [AnyAction] {
        []
    }
}

extension TupleAction: Decomposable {
    func decompose() -> [AnyAction] {
        let mirror = Mirror(reflecting: self)
        let value = mirror.children[mirror.children.startIndex].value
        let valueMirror = Mirror(reflecting: value)
        return valueMirror.children.flatMap { label, value in AnyAction(_fromValue: value)!.decompose() }
    }
}
