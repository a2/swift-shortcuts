public struct GetURLsFromInput: Shortcut {
    let input: Text

    public var body: some Shortcut {
        Action(identifier: "is.workflow.actions.detect.link", parameters: Parameters(base: self))
    }

    public init(input: Text) {
        self.input = input
    }
}

extension GetURLsFromInput {
    struct Parameters: Encodable {
        enum CodingKeys: String, CodingKey {
            case input = "WFInput"
        }

        let base: GetURLsFromInput

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(base.input, forKey: .input)
        }
    }
}
