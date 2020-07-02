/// This action lets you explain how part of a shortcut works. When run, this action does nothing.
public struct Comment: Shortcut {
    let text: String

    /// The contents of the shortcut.
    public var body: some Shortcut {
        Action(identifier: "is.workflow.actions.comment", parameters: Parameters(base: self))
    }

    /// Initializes the shortcut.
    /// - Parameter text: An explanatory text.
    public init(_ text: String) {
        self.text = text
    }
}

extension Comment {
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
}
