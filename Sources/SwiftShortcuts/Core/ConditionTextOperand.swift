public enum ConditionTextOperand {
    case text(Text)

    var baseOperand: ConditionOperand {
        switch self {
        case .text(let text):
            return .text(text)
        }
    }
}

extension ConditionTextOperand: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .text(Text(value))
    }
}

extension ConditionTextOperand: ExpressibleByStringInterpolation {
    public init(stringInterpolation: Text.StringInterpolation) {
        self = .text(Text(stringInterpolation: stringInterpolation))
    }
}
