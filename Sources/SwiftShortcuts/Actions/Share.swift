/// Prompts to share the input.
///
/// **Input:** Anything
///
/// **Result:** (Anything) The input
public struct Share: Shortcut {
    let input: Variable

    /// The contents of the shortcut.
    public var body: some Shortcut {
        Action(identifier: "is.workflow.actions.share", parameters: Parameters(base: self))
    }

    /// Initializes the shortcut.
    /// - Parameter input: The content to share.
    public init(input: Variable) {
        self.input = input
    }
}

extension Share {
    struct Parameters: Encodable {
        enum CodingKeys: String, CodingKey {
            case input = "WFInput"
        }

        let base: Share

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(base.input, forKey: .input)
        }
    }
}
