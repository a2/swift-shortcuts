public enum ConditionTextOperand {
    case interpolatedText(InterpolatedText)

    var baseOperand: ConditionOperand {
        switch self {
        case .interpolatedText(let interpolatedText):
            return .interpolatedText(interpolatedText)
        }
    }
}

extension ConditionTextOperand: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .interpolatedText(InterpolatedText(value))
    }
}

extension ConditionTextOperand: ExpressibleByStringInterpolation {
    public init(stringInterpolation: InterpolatedText.StringInterpolation) {
        self = .interpolatedText(InterpolatedText(stringInterpolation: stringInterpolation))
    }
}
