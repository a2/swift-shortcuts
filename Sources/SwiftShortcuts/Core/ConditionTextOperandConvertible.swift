public protocol ConditionTextOperandConvertible {
    var conditionTextOperand: ConditionTextOperand { get }
}

extension ConditionTextOperand: ConditionTextOperandConvertible {
    public var conditionTextOperand: ConditionTextOperand { self }
}

extension Variable: ConditionTextOperandConvertible {
    public var conditionTextOperand: ConditionTextOperand { .interpolatedText("\(self)") }
}

extension InterpolatedText: ConditionTextOperandConvertible {
    public var conditionTextOperand: ConditionTextOperand { .interpolatedText(self) }
}

extension String: ConditionTextOperandConvertible {
    public var conditionTextOperand: ConditionTextOperand { .interpolatedText(InterpolatedText(self)) }
}
