/// An operand for a `Condition` that can represent either a `Number` or a `Variable`.
public enum ConditionNumberOperand {
    /// A variable operand.
    case variable(Variable)

    /// A number operand.
    case number(Number)

    var baseOperand: ConditionOperand {
        switch self {
        case .variable(let variable):
            return .variable(variable)
        case .number(let number):
            return .number(number)
        }
    }
}

extension ConditionNumberOperand: ExpressibleByFloatLiteral {
    /// Creates an instance initialized to the specified floating-point value.
    ///
    /// - Attention: Do not call this initializer directly. Instead, initialize a variable or constant using a floating-point literal.
    ///
    /// - Parameter value: The value of the new instance.
    public init(floatLiteral value: Double) {
        self = .number(Number(value))
    }
}

extension ConditionNumberOperand: ExpressibleByIntegerLiteral {
    /// Creates an instance initialized to the specified integer value.
    ///
    /// - Attention: Do not call this initializer directly. Instead, initialize a variable or constant using an integer literal.
    ///
    /// - Parameter value: The value of the new instance.
    public init(integerLiteral value: Int64) {
        self = .number(Number(value))
    }
}
