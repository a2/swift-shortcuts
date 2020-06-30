public struct Action: Shortcut {
    let identifier: String
    let parameters: AnyEncodable

    public init(identifier: String) {
        self.init(identifier: identifier, parameters: EmptyParameters())
    }

    public init<Parameters>(identifier: String, parameters: Parameters) where Parameters: Encodable {
        self.identifier = identifier
        self.parameters = AnyEncodable(parameters)
    }

    public typealias Body = Never
    public var body: Never { fatalError() }

    func encodable() -> ActionWrapper {
        return ActionWrapper(self)
    }
}
