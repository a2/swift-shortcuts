/// The evaluated logic that determines which branch to follow. Evaluated by `If` shortcuts.
public enum Condition {
    /// This condition evaluates to true if the variable equals the condition operand.
    case `is`(Variable, ConditionOperand)

    /// This condition evaluates to true if the variable does not equal the condition operand.
    case isNot(Variable, ConditionOperand)

    /// This condition evaluates to true if the variable has any value.
    case hasAnyValue(Variable)

    /// This condition evaluates to true if the variable does not have any value.
    case doesNotHaveAnyValue(Variable)

    /// This condition evaluates to true if the variable contains the specified text.
    case contains(Variable, Text)

    /// This condition evaluates to true if the variable does not contain the specified text.
    case doesNotContain(Variable, Text)

    /// This condition evaluates to true if the variable begins with the specified text.
    case beginsWith(Variable, Text)

    /// This condition evaluates to true if the variable ends with the specified text.
    case endsWith(Variable, Text)

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

    /// Encodes this value into the given encoder.
    /// - Parameter encoder: The encoder to write data to.
    /// - Throws: This function throws an error if any values are invalid for the given encoder's format.
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
            let operand = ConditionOperand.text(rhs)
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

/// Makes a condition that evaluates to true if the left-hand variable equals the right-hand condition operand.
/// - Parameters:
///   - lhs: A variable.
///   - rhs: A value that can be converted to a condition operand
/// - Returns: An equality condition.
public func == (lhs: Variable, rhs: ConditionOperandConvertible) -> Condition {
    .is(lhs, rhs.conditionOperand)
}

/// Makes a condition that evaluates to true if the left-hand variable does not equal the right-hand condition operand.
/// - Parameters:
///   - lhs: A variable.
///   - rhs: A value that can be converted to a condition operand
/// - Returns: An inequality condition.
public func != (lhs: Variable, rhs: ConditionOperandConvertible) -> Condition {
    .isNot(lhs, rhs.conditionOperand)
}

/// Makes a condition that evaluates to true if the left-hand variable is less than the right-hand condition operand.
/// - Parameters:
///   - lhs: A variable.
///   - rhs: A value that can be converted to a condition operand
/// - Returns: A "less than" condition.
public func > (lhs: Variable, rhs: ConditionNumberOperandConvertible) -> Condition {
    .isGreaterThan(lhs, rhs.conditionNumberOperand)
}

/// Makes a condition that evaluates to true if the left-hand variable is less than or equal to the right-hand condition operand.
/// - Parameters:
///   - lhs: A variable.
///   - rhs: A value that can be converted to a condition operand
/// - Returns: A "less than or equal to" condition.
public func >= (lhs: Variable, rhs: ConditionNumberOperandConvertible) -> Condition {
    .isGreaterThanOrEqualTo(lhs, rhs.conditionNumberOperand)
}

/// Makes a condition that evaluates to true if the left-hand variable is greater than the right-hand condition operand.
/// - Parameters:
///   - lhs: A variable.
///   - rhs: A value that can be converted to a condition operand
/// - Returns: A "greater than" condition.
public func < (lhs: Variable, rhs: ConditionNumberOperandConvertible) -> Condition {
    .isLessThan(lhs, rhs.conditionNumberOperand)
}

/// Makes a condition that evaluates to true if the left-hand variable is greater than or equal to the right-hand condition operand.
/// - Parameters:
///   - lhs: A variable.
///   - rhs: A value that can be converted to a condition operand
/// - Returns: A "greater than or equal to" condition.
public func <= (lhs: Variable, rhs: ConditionNumberOperandConvertible) -> Condition {
    .isLessThanOrEqualTo(lhs, rhs.conditionNumberOperand)
}

/// Makes a condition that evaluates to true if the left-hand variable falls between the range in the right-hand condition operand.
/// - Parameters:
///   - lhs: A variable.
///   - rhs: A value that can be converted to a condition operand
/// - Returns: An "is between" condition.
public func ~= (lhs: Variable, rhs: ClosedRange<Number>) -> Condition {
    .isBetween(lhs, .number(rhs.lowerBound), .number(rhs.upperBound))
}

/// Makes a condition that evaluates to true if the left-hand variable falls between the range in the right-hand condition operand.
/// - Parameters:
///   - lhs: A variable.
///   - rhs: A value that can be converted to a condition operand
/// - Returns: An "is between" condition.
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
    public func contains(_ text: Text) -> Condition { .contains(self, text) }

    /// - Parameter text: A substring to search for.
    /// - Returns: A condition that evaluates to true if this variable does not contain the specified text.
    public func doesNotContain(_ text: Text) -> Condition { .doesNotContain(self, text) }

    /// - Parameter text: A prefix to search for.
    /// - Returns: A condition that evaluates to true if this variable contains the specified text as a prefix.
    public func hasPrefix(_ text: Text) -> Condition { .beginsWith(self, text) }

    /// - Parameter text: A prefix to search for.
    /// - Returns: A condition that evaluates to true if this variable contains the specified text as a suffix.
    public func hasSuffix(_ text: Text) -> Condition { .endsWith(self, text) }
}
