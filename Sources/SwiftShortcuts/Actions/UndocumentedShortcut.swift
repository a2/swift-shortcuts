public struct UndocumentedShortcut: Shortcut {
    public let value: Int

    public var body: some Shortcut {
        EmptyShortcut()
    }

    public init(value: Int) {
        self.value = value
    }
}

extension UndocumentedShortcut {
    public var value2: Int { value }
}

public extension UndocumentedShortcut {
    public var value3: Int { value }
}
