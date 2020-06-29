public struct Text: Shortcut {
    let text: InterpolatedText

    public var body: some Shortcut {
        Action(identifier: "is.workflow.actions.gettext", parameters: Parameters(base: self))
    }

    public init(_ text: InterpolatedText) {
        self.text = text
    }
}

extension Text {
    struct Parameters: Encodable {
        enum CodingKeys: String, CodingKey {
            case text = "WFTextActionText"
        }

        let base: Text

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(base.text, forKey: .text)
        }
    }
}
