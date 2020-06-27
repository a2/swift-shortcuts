public struct ForEach: Action {
    let children: [AnyAction]

    public typealias Body = Never
    public var body: Never { fatalError() }

    public init<C, Content>(_ collection: C, @ActionBuilder builder: (C.Element) -> Content) where C: Collection, Content: Action {
        self.children = collection.map { item in AnyAction(builder(item)) }
    }
}
