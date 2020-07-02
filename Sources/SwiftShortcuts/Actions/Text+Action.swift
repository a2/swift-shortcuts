extension Text: Shortcut {
    /// The contents of the shortcut.
    public var body: some Shortcut {
        Action(identifier: "is.workflow.actions.gettext", parameters: Parameters(base: self))
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
            try container.encode(base, forKey: .text)
        }
    }
}
