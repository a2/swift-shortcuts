/// Ask for Input: Prompts the user to enter a piece of information. Returns: Text
public struct Ask: Shortcut {
    let prompt: Text
    let defaultAnswer: Text?

    public var body: some Shortcut {
        Action(identifier: "is.workflow.actions.ask", parameters: Parameters(base: self))
    }

    public init(prompt: Text, defaultAnswer: Text? = nil) {
        self.prompt = prompt
        self.defaultAnswer = defaultAnswer
    }
}

extension Ask {
    struct Parameters: Encodable {
        enum CodingKeys: String, CodingKey {
            case prompt = "WFAskActionPrompt"
            case defaultAnswer = "WFAskActionDefaultAnswer"
        }

        let base: Ask

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(base.prompt, forKey: .prompt)
            try container.encodeIfPresent(base.defaultAnswer, forKey: .defaultAnswer)
        }
    }
}
