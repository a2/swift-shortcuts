/// An operand for a `Condition` that can represent either a `Number`, a `Variable`, or `Text`.
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

    /// A variable operand.
    case variable(Variable)

    /// A number operand.
    case number(Number)

    /// A text operand.
    case text(Text)

    /// Encodes this value into the given encoder.
    /// - Parameter encoder: The encoder to write data to.
    /// - Throws: This function throws an error if any values are invalid for the given encoder's format.
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
    /// Creates an instance initialized to the specified floating-point value.
    ///
    /// - Attention: Do not call this initializer directly. Instead, initialize a variable or constant using a floating-point literal.
    ///
    /// - Parameter value: The value of the new instance.
    public init(floatLiteral value: Double) {
        self = .number(Number(value))
    }
}

extension ConditionOperand: ExpressibleByIntegerLiteral {
    /// Creates an instance initialized to the specified integer value.
    ///
    /// - Attention: Do not call this initializer directly. Instead, initialize a variable or constant using an integer literal.
    ///
    /// - Parameter value: The value of the new instance.
    public init(integerLiteral value: Int64) {
        self = .number(Number(value))
    }
}

extension ConditionOperand: ExpressibleByStringLiteral {
    /// Creates an instance initialized to the given string value.
    ///
    /// - Attention: Do not call this initializer directly. Instead, initialize a variable or constant using a string literal.
    ///
    /// - Parameter value: The value of the new instance.
    public init(stringLiteral value: String) {
        self = .text(Text(value))
    }
}

extension ConditionOperand: ExpressibleByStringInterpolation {
    /// Creates an instance from a string interpolation.
    ///
    /// - Attention: Do not call this initializer directly. Instead, initialize a variable or constant using an interpolated string literal.
    ///
    /// - Parameter stringInterpolation: An instance of `StringInterpolation` which has had each segment of the string literal appended to it.
    public init(stringInterpolation: Text.StringInterpolation) {
        self = .text(Text(stringInterpolation: stringInterpolation))
    }
}
