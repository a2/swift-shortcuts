/// An operand for a `Condition` that can represent a `Text` value.
public enum ConditionTextOperand {
    /// A text operand.
    case text(Text)

    var baseOperand: ConditionOperand {
        switch self {
        case .text(let text):
            return .text(text)
        }
    }
}

extension ConditionTextOperand: ExpressibleByStringLiteral {
    /// Creates an instance initialized to the given string value.
    ///
    /// - Attention: Do not call this initializer directly. Instead, initialize a variable or constant using a string literal.
    ///
    /// - Parameter value: The value of the new instance.
    public init(stringLiteral value: String) {
        self = .text(Text(value))
    }
}

extension ConditionTextOperand: ExpressibleByStringInterpolation {
    /// Creates an instance from a string interpolation.
    ///
    /// - Attention: Do not call this initializer directly. Instead, initialize a variable or constant using an interpolated string literal.
    ///
    /// - Parameter stringInterpolation: An instance of `StringInterpolation` which has had each segment of the string literal appended to it.
    public init(stringInterpolation: Text.StringInterpolation) {
        self = .text(Text(stringInterpolation: stringInterpolation))
    }
}
