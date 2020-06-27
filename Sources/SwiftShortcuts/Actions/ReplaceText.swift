public struct ReplaceText: Action {
    let text: InterpolatedText
    let target: InterpolatedText
    let replacement: InterpolatedText
    let isCaseSensitive: Bool
    let isRegularExpression: Bool

    public var body: some Action {
        ActionComponent(identifier: "is.workflow.actions.text.replace", parameters: Parameters(base: self))
    }

    public init(text: InterpolatedText, target: InterpolatedText, replacement: InterpolatedText, isCaseSensitive: Bool = true, isRegularExpression: Bool = false) {
        self.text = text
        self.target = target
        self.replacement = replacement
        self.isCaseSensitive = isCaseSensitive
        self.isRegularExpression = isRegularExpression
    }

    public init(variable: Variable, target: InterpolatedText, replacement: InterpolatedText, isCaseSensitive: Bool = true, isRegularExpression: Bool = false) {
        self.init(text: "\(variable)", target: target, replacement: replacement, isCaseSensitive: isCaseSensitive, isRegularExpression: isRegularExpression)
    }
}

extension ReplaceText {
    struct Parameters: Encodable {
        enum CodingKeys: String, CodingKey {
            case text = "WFInput"
            case target = "WFReplaceTextFind"
            case replacement = "WFReplaceTextReplace"
            case isCaseSensitive = "WFReplaceTextCaseSensitive"
            case isRegularExpression = "WFReplaceTextRegularExpression"
        }

        let base: ReplaceText

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(base.text, forKey: .text)
            try container.encode(base.target, forKey: .target)
            try container.encode(base.replacement, forKey: .replacement)
            try container.encode(base.isCaseSensitive, forKey: .isCaseSensitive)
            try container.encode(base.isRegularExpression, forKey: .isRegularExpression)
        }
    }
}
