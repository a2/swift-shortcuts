public struct Ask: Action {
    let prompt: InterpolatedText
    let defaultAnswer: InterpolatedText?

    public var body: some Action {
        ActionComponent(identifier: "is.workflow.actions.ask", parameters: Parameters(base: self))
    }

    public init(prompt: InterpolatedText, defaultAnswer: InterpolatedText? = nil) {
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
