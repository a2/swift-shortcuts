public struct ForEach: Shortcut {
    let children: [AnyShortcut]

    public typealias Body = Never
    public var body: Never { fatalError() }

    public init<Data, Content>(_ data: Data, @ShortcutBuilder builder: (Data.Element) -> Content) where Data: Collection, Content: Shortcut {
        self.children = data.map { item in AnyShortcut(builder(item)) }
    }
}
