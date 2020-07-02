/// Represents a value that can be converted into a `ConditionOperand`, such as a `Number`, `Variable`, `Text`, or `String`.
public protocol ConditionOperandConvertible {
    /// An operand that represents this value.
    var conditionOperand: ConditionOperand { get }
}

extension ConditionOperand: ConditionOperandConvertible {
    /// An operand that represents this value.
    public var conditionOperand: ConditionOperand { self }
}

extension Number: ConditionOperandConvertible {
    /// An operand that represents this value.
    public var conditionOperand: ConditionOperand { .number(self) }
}

extension Variable: ConditionOperandConvertible {
    /// An operand that represents this value.
    public var conditionOperand: ConditionOperand { .variable(self) }
}

extension Text: ConditionOperandConvertible {
    /// An operand that represents this value.
    public var conditionOperand: ConditionOperand { .text(self) }
}

extension String: ConditionOperandConvertible {
    /// An operand that represents this value.
    public var conditionOperand: ConditionOperand { .text(Text(self)) }
}
