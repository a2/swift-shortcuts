public enum Condition {
    case `is`(Variable, ConditionOperand)
    case isNot(Variable, ConditionOperand)

    case hasAnyValue(Variable)
    case doesNotHaveAnyValue(Variable)

    case contains(Variable, InterpolatedText)
    case doesNotContain(Variable, InterpolatedText)
    case beginsWith(Variable, InterpolatedText)
    case endsWith(Variable, InterpolatedText)

    case isGreaterThan(Variable, ConditionNumberOperand)
    case isGreaterThanOrEqualTo(Variable, ConditionNumberOperand)
    case isLessThan(Variable, ConditionNumberOperand)
    case isLessThanOrEqualTo(Variable, ConditionNumberOperand)
    case isBetween(Variable, ConditionNumberOperand, ConditionNumberOperand)

    var conditionType: ConditionType {
        switch self {
        case .is:
            return .is
        case .isNot:
            return .isNot
        case .hasAnyValue:
            return .hasAnyValue
        case .doesNotHaveAnyValue:
            return .doesNotHaveAnyValue
        case .contains:
            return .contains
        case .doesNotContain:
            return .doesNotContain
        case .beginsWith:
            return .beginsWith
        case .endsWith:
            return .endsWith
        case .isGreaterThan:
            return .isGreaterThan
        case .isGreaterThanOrEqualTo:
            return .isGreaterThanOrEqualTo
        case .isLessThan:
            return .isLessThan
        case .isLessThanOrEqualTo:
            return .isLessThanOrEqualTo
        case .isBetween:
            return .isBetween
        }
    }
}

extension Condition: Encodable {
    enum CodingKeys: String, CodingKey {
        case input = "WFInput"
        case condition = "WFCondition"
        case serializationType = "WFSerializationType"
        case conditionalActionString = "WFConditionalActionString"
        case numberValue = "WFNumberValue"
        case anotherNumber = "WFAnotherNumber"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(ConditionOperand.variable(lhs), forKey: .input)
        try container.encode(conditionType, forKey: .condition)

        switch self {
        case .is(_, let rhs),
             .isNot(_, let rhs):
            try rhs.encode(to: encoder)

        case .hasAnyValue, .doesNotHaveAnyValue:
            break

        case .contains(_, let rhs),
             .doesNotContain(_, let rhs),
             .beginsWith(_, let rhs),
             .endsWith(_, let rhs):
            let operand = ConditionOperand.interpolatedText(rhs)
            try operand.encode(to: encoder)

        case .isGreaterThan(_, let rhs),
             .isGreaterThanOrEqualTo(_, let rhs),
             .isLessThan(_, let rhs),
             .isLessThanOrEqualTo(_, let rhs):
            try rhs.baseOperand.encode(to: encoder)

        case .isBetween(_, let lowerBound, let upperBound):
            try container.encode(lowerBound.baseOperand, forKey: .numberValue)
            try container.encode(upperBound.baseOperand, forKey: .anotherNumber)
        }
    }

    var lhs: Variable {
        switch self {
        case .is(let variable, _),
             .isNot(let variable, _),
             .hasAnyValue(let variable),
             .doesNotHaveAnyValue(let variable),
             .contains(let variable, _),
             .doesNotContain(let variable, _),
             .beginsWith(let variable, _),
             .endsWith(let variable, _),
             .isGreaterThan(let variable, _),
             .isGreaterThanOrEqualTo(let variable, _),
             .isLessThan(let variable, _),
             .isLessThanOrEqualTo(let variable, _),
             .isBetween(let variable, _, _):
            return variable
        }
    }
}

// MARK: - ConditionOperand

public enum ConditionOperand: Encodable {
    enum CodingKeys: String, CodingKey {
        case type = "Type"
        case variable = "Variable"
        case numberValue = "WFNumberValue"
        case conditionalActionString = "WFConditionalActionString"
    }

    enum OperandType: String, Encodable {
        case variable = "Variable"
    }

    case variable(Variable)
    case number(Number)
    case interpolatedText(InterpolatedText)

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .variable(let variable):
            try container.encode(OperandType.variable, forKey: .type)
            try container.encode(variable, forKey: .variable)
        case .number(let number):
            try container.encode(number, forKey: .numberValue)
        case .interpolatedText(let interpolatedText):
            try container.encode(interpolatedText, forKey: .conditionalActionString)
        }
    }
}

public protocol ConditionOperandConvertible {
    var conditionOperand: ConditionOperand { get }
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

// MARK: - ConditionNumericOperand

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

// MARK: - ConditionTextOperand

public enum ConditionTextOperand {
    case interpolatedText(InterpolatedText)

    var baseOperand: ConditionOperand {
        switch self {
        case .interpolatedText(let interpolatedText):
            return .interpolatedText(interpolatedText)
        }
    }
}

public protocol ConditionTextOperandConvertible {
    var conditionTextOperand: ConditionTextOperand { get }
}

extension Variable: ConditionTextOperandConvertible {
    public var conditionTextOperand: ConditionTextOperand { .interpolatedText("\(self)") }
}

extension InterpolatedText: ConditionTextOperandConvertible {
    public var conditionTextOperand: ConditionTextOperand { .interpolatedText(self) }
}

// MARK: - Functions

public func == (lhs: Variable, rhs: ConditionOperandConvertible) -> Condition {
    .is(lhs, rhs.conditionOperand)
}

public func != (lhs: Variable, rhs: ConditionOperandConvertible) -> Condition {
    .isNot(lhs, rhs.conditionOperand)
}

public func > (lhs: Variable, rhs: ConditionNumberOperandConvertible) -> Condition {
    .isGreaterThan(lhs, rhs.conditionNumberOperand)
}

public func >= (lhs: Variable, rhs: ConditionNumberOperandConvertible) -> Condition {
    .isGreaterThanOrEqualTo(lhs, rhs.conditionNumberOperand)
}

public func < (lhs: Variable, rhs: ConditionNumberOperandConvertible) -> Condition {
    .isLessThan(lhs, rhs.conditionNumberOperand)
}

public func <= (lhs: Variable, rhs: ConditionNumberOperandConvertible) -> Condition {
    .isLessThanOrEqualTo(lhs, rhs.conditionNumberOperand)
}

public func ~= (lhs: Variable, rhs: ClosedRange<Number>) -> Condition {
    .isBetween(lhs, .number(rhs.lowerBound), .number(rhs.upperBound))
}

public func ~= (lhs: Variable, rhs: (lowerBound: ConditionNumberOperandConvertible, upperBound: ConditionNumberOperandConvertible)) -> Condition {
    .isBetween(lhs, rhs.lowerBound.conditionNumberOperand, rhs.upperBound.conditionNumberOperand)
}

extension Variable {
    public func hasAnyValue() -> Condition { .hasAnyValue(self) }

    public func doesNotHaveAnyValue() -> Condition { .doesNotHaveAnyValue(self) }

    public func contains(_ text: InterpolatedText) -> Condition { .contains(self, text) }

    public func doesNotContain(_ text: InterpolatedText) -> Condition { .doesNotContain(self, text) }

    public func hasPrefix(_ text: InterpolatedText) -> Condition { .beginsWith(self, text) }

    public func hasSuffix(_ text: InterpolatedText) -> Condition { .endsWith(self, text) }
}
