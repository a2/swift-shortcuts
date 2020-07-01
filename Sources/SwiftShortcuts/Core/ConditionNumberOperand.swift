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

extension ConditionNumberOperand: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) {
        self = .number(Number(value))
    }
}

extension ConditionNumberOperand: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int64) {
        self = .number(Number(value))
    }
}
