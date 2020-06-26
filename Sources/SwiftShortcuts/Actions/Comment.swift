public struct Comment: Action {
    struct Parameters: Encodable {
        enum CodingKeys: String, CodingKey {
            case text = "WFCommentActionText"
        }

        let base: Comment

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(base.text, forKey: .text)
        }
    }

    public var body: some Action {
        ActionStep(identifier: "is.workflow.actions.comment", parameters: Parameters(base: self))
    }

    let text: String

    public init(_ text: String) {
        self.text = text
    }
}
