/// Represents a value that can be converted into a `ConditionNumberOperand`, such as a `Number` or `Variable`.
public protocol ConditionNumberOperandConvertible {
    /// A number operand that represents this value.
    var conditionNumberOperand: ConditionNumberOperand { get }
}

extension Number: ConditionNumberOperandConvertible {
    /// A number operand that represents this value.
    public var conditionNumberOperand: ConditionNumberOperand { .number(self) }
}

extension Variable: ConditionNumberOperandConvertible {
    /// A number operand that represents this value.
    public var conditionNumberOperand: ConditionNumberOperand { .variable(self) }
}
