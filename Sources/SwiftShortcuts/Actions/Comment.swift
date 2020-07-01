/// The "Comment" shortcut.
public struct Comment: Shortcut {
    let text: String

    public var body: some Shortcut {
        Action(identifier: "is.workflow.actions.comment", parameters: Parameters(base: self))
    }

    /// - Parameter text: The text content of the comment.
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
