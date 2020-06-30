public protocol ConditionOperandConvertible {
    var conditionOperand: ConditionOperand { get }
}

extension ConditionOperand: ConditionOperandConvertible {
    public var conditionOperand: ConditionOperand { self }
}

extension Number: ConditionOperandConvertible {
    public var conditionOperand: ConditionOperand { .number(self) }
}

extension Variable: ConditionOperandConvertible {
    public var conditionOperand: ConditionOperand { .variable(self) }
}

extension InterpolatedText: ConditionOperandConvertible {
    public var conditionOperand: ConditionOperand { .interpolatedText(self) }
}

extension String: ConditionOperandConvertible {
    public var conditionOperand: ConditionOperand { .interpolatedText(InterpolatedText(self)) }
}
