public enum ConditionNumberOperand {
    case variable(Variable)
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

public protocol ConditionNumberOperandConvertible {
    var conditionNumberOperand: ConditionNumberOperand { get }
}

extension Number: ConditionNumberOperandConvertible {
    public var conditionNumberOperand: ConditionNumberOperand { .number(self) }
}

extension Variable: ConditionNumberOperandConvertible {
    public var conditionNumberOperand: ConditionNumberOperand { .variable(self) }
}
