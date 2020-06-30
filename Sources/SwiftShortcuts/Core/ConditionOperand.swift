public enum ConditionOperand: Encodable {
    enum CodingKeys: String, CodingKey {
        case type = "Type"
        case variable = "Variable"
        case numberValue = "WFNumberValue"
        case conditionalActionString = "WFConditionalActionString"
    }

    enum OperandType: String, Encodable {
        case variable = "Variable"
    }

    case variable(Variable)
    case number(Number)
    case interpolatedText(InterpolatedText)

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .variable(let variable):
            try container.encode(OperandType.variable, forKey: .type)
            try container.encode(variable, forKey: .variable)
        case .number(let number):
            try container.encode(number, forKey: .numberValue)
        case .interpolatedText(let interpolatedText):
            try container.encode(interpolatedText, forKey: .conditionalActionString)
        }
    }
}

extension ConditionOperand: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .interpolatedText(InterpolatedText(value))
    }
}

extension ConditionOperand: ExpressibleByStringInterpolation {
    public init(stringInterpolation: InterpolatedText.StringInterpolation) {
        self = .interpolatedText(InterpolatedText(stringInterpolation: stringInterpolation))
    }
}
