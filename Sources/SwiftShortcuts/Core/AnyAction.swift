class AnyActionStorageBase {}

class AnyActionStorage<A: Action>: AnyActionStorageBase {
    var action: A

    init(_ action: A) {
        self.action = action
    }
}

public struct AnyAction: Action {
    let storage: AnyActionStorageBase

    public typealias Body = Never
    public var body: Never { fatalError() }

    public init<Base>(_ base: Base) where Base: Action {
        self.storage = AnyActionStorage(base)
    }
}
