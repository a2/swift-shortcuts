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
    case text(Text)

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .variable(let variable):
            try container.encode(OperandType.variable, forKey: .type)
            try container.encode(variable, forKey: .variable)
        case .number(let number):
            try container.encode(number, forKey: .numberValue)
        case .text(let text):
            try container.encode(text, forKey: .conditionalActionString)
        }
    }
}

extension ConditionOperand: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) {
        self = .number(Number(value))
    }
}

extension ConditionOperand: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int64) {
        self = .number(Number(value))
    }
}

extension ConditionOperand: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .text(Text(value))
    }
}

extension ConditionOperand: ExpressibleByStringInterpolation {
    public init(stringInterpolation: Text.StringInterpolation) {
        self = .text(Text(stringInterpolation: stringInterpolation))
    }
}
