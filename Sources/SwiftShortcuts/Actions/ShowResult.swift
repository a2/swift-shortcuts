/// Shows the specified text in Siri or in an alert.
///
/// **Input:** Text
///
/// **Input:** (Text) The input
public struct ShowResult: Shortcut {
    let text: Text

    /// The contents of the shortcut.
    public var body: some Shortcut {
        Action(identifier: "is.workflow.actions.showresult", parameters: Parameters(base: self))
    }

    /// Initializes the shortcut.
    /// - Parameter text: The text to display.
    public init(_ text: Text) {
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
