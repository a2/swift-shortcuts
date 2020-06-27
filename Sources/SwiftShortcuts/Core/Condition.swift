public struct Condition {
    enum Operation: Int, Encodable {
        case `is` = 4
        case isNot = 5
        case hasAnyValue = 100
        case doesNotHaveAnyValue = 101
        case isGreaterThan = 2
        case isGreaterThanOrEqualTo = 3
        case isLessThan = 0
        case isLessThanOrEqualTo = 1
        case isBetween = 1003
    }

    enum LeftOperand {
        case variable(Variable)
    }

    enum RightRangeOperand {
        case variable(Variable)
        case number(Number)
    }

    enum RightOperand {
        case variable(Variable)
        case number(Number)
        case range(RightRangeOperand, RightRangeOperand)
    }

    let lhs: LeftOperand
    let operation: Operation
    let rhs: RightOperand?
}

extension Condition: Encodable {
    enum CodingKeys: String, CodingKey {
        case input = "WFInput"
        case condition = "WFCondition"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(lhs, forKey: .input)
        try container.encode(operation, forKey: .condition)
        try rhs?.encode(to: encoder)
    }
}

extension Condition.LeftOperand: Encodable {
    enum CodingKeys: String, CodingKey {
        case type = "Type"
        case variable = "Variable"
    }

    enum OperandType: String, Encodable {
        case variable = "Variable"
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .variable(let variable):
            try container.encode(OperandType.variable, forKey: .type)
            try container.encode(variable, forKey: .variable)
        }
    }
}

extension Condition.RightOperand: Encodable {
    enum CodingKeys: String, CodingKey {
        case serializationType = "WFSerializationType"
        case numberValue = "WFNumberValue"
        case anotherNumber = "WFAnotherNumber"
    }

    enum SerializationType: String, Encodable {
        case tokenTextAttachment = "WFTextTokenAttachment"
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .variable(let variable):
            try variable.encode(to: encoder)
            try container.encode(SerializationType.tokenTextAttachment, forKey: .serializationType)
        case .number(let number):
            try container.encode(number, forKey: .numberValue)
        case .range(let lhs, let rhs):
            try container.encode(lhs, forKey: .numberValue)
            try container.encode(rhs, forKey: .anotherNumber)
        }
    }
}

extension Condition.RightRangeOperand: Encodable {
    enum CodingKeys: String, CodingKey {
        case type = "Type"
        case variable = "Variable"
    }

    enum OperandType: String, Encodable {
        case variable = "Variable"
    }

    func encode(to encoder: Encoder) throws {
        switch self {
        case .variable(let variable):
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(OperandType.variable, forKey: .type)
            try container.encode(variable.value, forKey: .variable)
        case .number(let number):
            var container = encoder.singleValueContainer()
            try container.encode(number)
        }
    }
}

public func > (lhs: Variable, rhs: Number) -> Condition {
    Condition(lhs: .variable(lhs), operation: .isGreaterThan, rhs: .number(rhs))
}

public func > (lhs: Variable, rhs: Variable) -> Condition {
    Condition(lhs: .variable(lhs), operation: .isGreaterThan, rhs: .variable(rhs))
}

public func >= (lhs: Variable, rhs: Number) -> Condition {
    Condition(lhs: .variable(lhs), operation: .isGreaterThanOrEqualTo, rhs: .number(rhs))
}

public func >= (lhs: Variable, rhs: Variable) -> Condition {
    Condition(lhs: .variable(lhs), operation: .isGreaterThanOrEqualTo, rhs: .variable(rhs))
}

public func < (lhs: Variable, rhs: Number) -> Condition {
    Condition(lhs: .variable(lhs), operation: .isLessThan, rhs: .number(rhs))
}

public func < (lhs: Variable, rhs: Variable) -> Condition {
    Condition(lhs: .variable(lhs), operation: .isLessThan, rhs: .variable(rhs))
}

public func <= (lhs: Variable, rhs: Number) -> Condition {
    Condition(lhs: .variable(lhs), operation: .isLessThanOrEqualTo, rhs: .number(rhs))
}

public func <= (lhs: Variable, rhs: Variable) -> Condition {
    Condition(lhs: .variable(lhs), operation: .isLessThanOrEqualTo, rhs: .variable(rhs))
}

public func ~= (lhs: Variable, rhs: ClosedRange<Number>) -> Condition {
    Condition(lhs: .variable(lhs), operation: .isBetween, rhs: .range(.number(rhs.lowerBound), .number(rhs.upperBound)))
}

public func ~= (lhs: Variable, rhs: (lowerBound: Number, upperBound: Number)) -> Condition {
    Condition(lhs: .variable(lhs), operation: .isBetween, rhs: .range(.number(rhs.lowerBound), .number(rhs.upperBound)))
}

public func ~= (lhs: Variable, rhs: (lowerBound: Variable, upperBound: Number)) -> Condition {
    Condition(lhs: .variable(lhs), operation: .isBetween, rhs: .range(.variable(rhs.lowerBound), .number(rhs.upperBound)))
}

public func ~= (lhs: Variable, rhs: (lowerBound: Number, upperBound: Variable)) -> Condition {
    Condition(lhs: .variable(lhs), operation: .isBetween, rhs: .range(.number(rhs.lowerBound), .variable(rhs.upperBound)))
}

public func ~= (lhs: Variable, rhs: (lowerBound: Variable, upperBound: Variable)) -> Condition {
    Condition(lhs: .variable(lhs), operation: .isBetween, rhs: .range(.variable(rhs.lowerBound), .variable(rhs.upperBound)))
}
