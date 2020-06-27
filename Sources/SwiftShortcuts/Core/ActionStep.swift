public struct ActionStep: Action {
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

    func encodable() -> EncodableWrapper {
        return EncodableWrapper(self)
    }
}

extension ActionStep {
    struct EncodableWrapper {
        let actionStep: ActionStep

        init(_ actionStep: ActionStep) {
            self.actionStep = actionStep
        }
    }
}

extension ActionStep.EncodableWrapper: Encodable {
    enum CodingKeys: String, CodingKey {
        case identifier = "WFWorkflowActionIdentifier"
        case parameters = "WFWorkflowActionParameters"
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(actionStep.identifier, forKey: .identifier)
        try container.encode(actionStep.parameters, forKey: .parameters)
    }
}
