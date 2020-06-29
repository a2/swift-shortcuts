public struct GetType: Shortcut {
    let input: Variable

    public var body: some Shortcut {
        Action(identifier: "is.workflow.actions.getitemtype", parameters: Parameters(base: self))
    }

    public init(input: Variable) {
        self.input = input
    }
}

extension GetType {
    struct Parameters: Encodable {
        enum CodingKeys: String, CodingKey {
            case input = "WFInput"
        }

        let base: GetType

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(base.input, forKey: .input)
        }
    }
}
