public struct ActionComponent: Action {
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

    func encodable() -> ActionComponentWrapper {
        return ActionComponentWrapper(self)
    }
}

struct ActionComponentWrapper: Encodable {
    enum CodingKeys: String, CodingKey {
        case identifier = "WFWorkflowActionIdentifier"
        case parameters = "WFWorkflowActionParameters"
    }

    let component: ActionComponent

    init(_ component: ActionComponent) {
        self.component = component
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(component.identifier, forKey: .identifier)
        try container.encode(component.parameters, forKey: .parameters)
    }
}
