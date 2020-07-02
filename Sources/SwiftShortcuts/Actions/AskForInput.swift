/// Prompts the user to enter a piece of information.
///
/// **Result:** Text
public struct AskForInput: Shortcut {
    let prompt: Text
    let defaultAnswer: Text?

    /// The contents of the shortcut.
    public var body: some Shortcut {
        Action(identifier: "is.workflow.actions.ask", parameters: Parameters(base: self))
    }

    /// Initializes the shortcut.
    /// - Parameters:
    ///   - prompt: The instruction provided when the list is presented.
    ///   - defaultAnswer: The result to use if no answer is provided.
    public init(prompt: Text, defaultAnswer: Text? = nil) {
        self.prompt = prompt
        self.defaultAnswer = defaultAnswer
    }
}

extension AskForInput {
    struct Parameters: Encodable {
        enum CodingKeys: String, CodingKey {
            case prompt = "WFAskActionPrompt"
            case defaultAnswer = "WFAskActionDefaultAnswer"
        }

        let base: AskForInput

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(base.prompt, forKey: .prompt)
            try container.encodeIfPresent(base.defaultAnswer, forKey: .defaultAnswer)
        }
    }
}
