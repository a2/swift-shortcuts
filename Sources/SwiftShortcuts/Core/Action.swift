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

struct ActionWrapper: Encodable {
    enum CodingKeys: String, CodingKey {
        case identifier = "WFWorkflowActionIdentifier"
        case parameters = "WFWorkflowActionParameters"
    }

    let action: Action

    init(_ action: Action) {
        self.action = action
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(action.identifier, forKey: .identifier)
        try container.encode(action.parameters, forKey: .parameters)
    }
}
