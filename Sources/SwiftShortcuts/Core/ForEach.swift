public struct ForEach: Action {
    let children: [AnyAction]

    public typealias Body = Never
    public var body: Never { fatalError() }

    public init<Data, Content>(_ data: Data, @ActionBuilder builder: (Data.Element) -> Content) where Data: Collection, Content: Action {
        self.children = data.map { item in AnyAction(builder(item)) }
    }
}
