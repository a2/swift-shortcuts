public protocol ConditionNumberOperandConvertible {
    var conditionNumberOperand: ConditionNumberOperand { get }
}

extension Number: ConditionNumberOperandConvertible {
    public var conditionNumberOperand: ConditionNumberOperand { .number(self) }
}

extension Variable: ConditionNumberOperandConvertible {
    public var conditionNumberOperand: ConditionNumberOperand { .variable(self) }
}
