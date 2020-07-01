/// Represents a value that can be evaluated by an `If` shortcut.
public enum Condition {
    /// This condition evaluates to true if the variable equals the condition operand.
    case `is`(Variable, ConditionOperand)
    /// This condition evaluates to true if the variable does not equal the condition operand.
    case isNot(Variable, ConditionOperand)

    /// This condition evaluates to true if the variable has any value.
    case hasAnyValue(Variable)
    /// This condition evaluates to true if the variable does not have any value.
    case doesNotHaveAnyValue(Variable)

    /// This condition evaluates to true if the variable contains the specified interpolated text..
    case contains(Variable, InterpolatedText)
    /// This condition evaluates to true if the variable does not contain the specified interpolated text.
    case doesNotContain(Variable, InterpolatedText)
    /// This condition evaluates to true if the variable begins with the specified interpolated text.
    case beginsWith(Variable, InterpolatedText)
    /// This condition evaluates to true if the variable ends with the specified interpolated text.
    case endsWith(Variable, InterpolatedText)

    /// This condition evaluates to true if the variable is greater than the condition operand.
    case isGreaterThan(Variable, ConditionNumberOperand)
    /// This condition evaluates to true if the variable is greater than or equal to the condition operand.
    case isGreaterThanOrEqualTo(Variable, ConditionNumberOperand)
    /// This condition evaluates to true if the variable is less than the condition operand.
    case isLessThan(Variable, ConditionNumberOperand)
    /// This condition evaluates to true if the variable is less than or equal to the condition operand.
    case isLessThanOrEqualTo(Variable, ConditionNumberOperand)
    /// This condition evaluates to true if the variable is between the two condition operands.
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

// MARK: - Making a Condition

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
    /// - Returns: A condition that evaluates to true if this variable has any value.
    public func hasAnyValue() -> Condition { .hasAnyValue(self) }

    /// - Returns: A condition that evaluates to true if this variable does not have any value.
    public func doesNotHaveAnyValue() -> Condition { .doesNotHaveAnyValue(self) }

    /// - Parameter text: A substring to search for.
    /// - Returns: A condition that evaluates to true if this variable contains the specified text.
    public func contains(_ text: InterpolatedText) -> Condition { .contains(self, text) }

    /// - Parameter text: A substring to search for.
    /// - Returns: A condition that evaluates to true if this variable does not contain the specified text.
    public func doesNotContain(_ text: InterpolatedText) -> Condition { .doesNotContain(self, text) }

    /// - Parameter text: A prefix to search for.
    /// - Returns: A condition that evaluates to true if this variable contains the specified text as a prefix.
    public func hasPrefix(_ text: InterpolatedText) -> Condition { .beginsWith(self, text) }

    /// - Parameter text: A prefix to search for.
    /// - Returns: A condition that evaluates to true if this variable contains the specified text as a suffix.
    public func hasSuffix(_ text: InterpolatedText) -> Condition { .endsWith(self, text) }
}
