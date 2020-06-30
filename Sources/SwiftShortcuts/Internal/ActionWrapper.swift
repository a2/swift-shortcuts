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
