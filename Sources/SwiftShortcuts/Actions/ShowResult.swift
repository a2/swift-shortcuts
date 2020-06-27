public struct ShowResult: Action {
    let text: InterpolatedText

    public var body: some Action {
        ActionStep(identifier: "is.workflow.actions.showresult", parameters: Parameters(base: self))
    }

    public init(_ text: InterpolatedText) {
        self.text = text
    }
}

extension ShowResult {
    struct Parameters: Encodable {
        enum CodingKeys: String, CodingKey {
            case text = "Text"
        }

        let base: ShowResult

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(base.text, forKey: .text)
        }
    }
}
