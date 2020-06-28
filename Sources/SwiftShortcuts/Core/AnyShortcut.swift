class AnyShortcutStorageBase {}

class AnyShortcutStorage<S: Shortcut>: AnyShortcutStorageBase {
    var action: S

    init(_ action: S) {
        self.action = action
    }
}

public struct AnyShortcut: Shortcut {
    let storage: AnyShortcutStorageBase

    public typealias Body = Never
    public var body: Never { fatalError() }

    public init<Base>(_ base: Base) where Base: Shortcut {
        self.storage = AnyShortcutStorage(base)
    }
}
