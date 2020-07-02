/// Represents a value that can be converted into a `ConditionTextOperand`, such as a `Variable`, `Text`, or `String`.
public protocol ConditionTextOperandConvertible {
    /// A text operand that represents this value.
    var conditionTextOperand: ConditionTextOperand { get }
}

extension ConditionTextOperand: ConditionTextOperandConvertible {
    /// A text operand that represents this value.
    public var conditionTextOperand: ConditionTextOperand { self }
}

extension Variable: ConditionTextOperandConvertible {
    /// A text operand that represents this value.
    public var conditionTextOperand: ConditionTextOperand { .text("\(self)") }
}

extension Text: ConditionTextOperandConvertible {
    /// A text operand that represents this value.
    public var conditionTextOperand: ConditionTextOperand { .text(self) }
}

extension String: ConditionTextOperandConvertible {
    /// A text operand that represents this value.
    public var conditionTextOperand: ConditionTextOperand { .text(Text(self)) }
}
