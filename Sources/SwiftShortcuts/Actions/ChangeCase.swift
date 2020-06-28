public struct ChangeCase: Shortcut {
    public enum Target: Encodable {
        case caseType(TextCase)
        case askEachTime

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
            case .caseType(let caseType):
                try container.encode(caseType)
            case .askEachTime:
                try container.encode(Variable.askEachTime)
            }
        }
    }

    let text: TextInput
    let target: Target

    public var body: some Shortcut {
        Action(identifier: "is.workflow.actions.text.changecase", parameters: Parameters(base: self))
    }

    public init(text: InterpolatedText, target: Target) {
        self.target = target
        self.text = .interpolatedText(text)
    }

    public init(variable: Variable, target: Target) {
        self.target = target
        self.text = .variable(variable)
    }
}

extension ChangeCase {
    struct Parameters: Encodable {
        enum CodingKeys: String, CodingKey {
            case caseType = "WFCaseType"
            case text
        }

        let base: ChangeCase

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(base.text, forKey: .text)
            try container.encode(base.target, forKey: .caseType)
        }
    }
}
