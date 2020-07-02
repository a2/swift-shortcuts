public protocol ConditionTextOperandConvertible {
    var conditionTextOperand: ConditionTextOperand { get }
}

extension ConditionTextOperand: ConditionTextOperandConvertible {
    public var conditionTextOperand: ConditionTextOperand { self }
}

extension Variable: ConditionTextOperandConvertible {
    public var conditionTextOperand: ConditionTextOperand { .text("\(self)") }
}

extension Text: ConditionTextOperandConvertible {
    public var conditionTextOperand: ConditionTextOperand { .text(self) }
}

extension String: ConditionTextOperandConvertible {
    public var conditionTextOperand: ConditionTextOperand { .text(Text(self)) }
}
