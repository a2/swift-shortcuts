public struct ForEach<Data, Content>: Action where Data: Collection, Content: Action {
    let children: [Content]

    public typealias Body = Never
    public var body: Never { fatalError() }

    public init(_ collection: Data, @ActionBuilder builder: (Data.Element) -> Content) {
        self.children = collection.map(builder)
    }
}
