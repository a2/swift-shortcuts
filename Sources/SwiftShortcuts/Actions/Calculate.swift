/// Performs a number operation on the input and returns the result.
///
/// **Input:** Text, Health sample, Boolean, Workout sample, Blood pressure, Number, Time interval, Date, File size, Currency Amount, Measurement
///
/// **Result:** Number
public struct Calculate: Shortcut {
    let calculation: Calculation

    /// The contents of the shortcut.
    public var body: some Shortcut {
        Action(identifier: "is.workflow.actions.math", parameters: Parameters(base: self))
    }

    /// Initializes the shortcut.
    /// - Parameter calculation: The calculation to compute.
    public init(_ calculation: Calculation) {
        self.calculation = calculation
    }
}

extension Calculate {
    struct Parameters: Encodable {
        enum CodingKeys: String, CodingKey {
            case lhs = "WFInput"
            case operation = "WFMathOperation"
            case rhs = "WFMathOperand"
        }

        enum Operation: String, Encodable {
            case add = "+"
            case subtract = "-"
            case multiply = "×"
            case divide = "÷"
        }

        let base: Calculate

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            switch base.calculation {
            case .add(let lhs, let rhs):
                try container.encode(lhs, forKey: .lhs)
                try container.encode(Operation.add, forKey: .operation)
                try container.encode(rhs, forKey: .rhs)
            case .subtract(let lhs, let rhs):
                try container.encode(lhs, forKey: .lhs)
                try container.encode(Operation.subtract, forKey: .operation)
                try container.encode(rhs, forKey: .rhs)
            case .multiply(let lhs, let rhs):
                try container.encode(lhs, forKey: .lhs)
                try container.encode(Operation.multiply, forKey: .operation)
                try container.encode(rhs, forKey: .rhs)
            case .divide(let lhs, let rhs):
                try container.encode(lhs, forKey: .lhs)
                try container.encode(Operation.divide, forKey: .operation)
                try container.encode(rhs, forKey: .rhs)
            case .askEachTime(let lhs, let rhs):
                try container.encode(lhs, forKey: .lhs)
                try container.encode(Variable.askEachTime, forKey: .operation)
                try container.encodeIfPresent(rhs, forKey: .rhs)
            }
        }
    }
}

/// A calculable expression to be used in conjunction with the `Calculate` shorcut.
public enum Calculation {
    /// Adds the left operand to the right operand.
    case add(CalculationOperand, CalculationOperand)

    /// Subtracts the right operand from the left operand.
    case subtract(CalculationOperand, CalculationOperand)

    /// Multiplies the two operands.
    case multiply(CalculationOperand, CalculationOperand)

    /// Divides the left operand by the right operand.
    case divide(CalculationOperand, CalculationOperand)

    /// Runs a calculation based on the user's input.
    case askEachTime(CalculationOperand, CalculationOperand?)
}

/// A `Calculation`-compatible operand used by the `Calculate` shortcut.
public enum CalculationOperand: Encodable {
    /// A variable operand.
    case variable(Variable)
    /// A constant operand.
    case number(Number)

    /// Encodes this value into the given encoder.
    /// - Parameter encoder: The encoder to write data to.
    /// - Throws: This function throws an error if any values are invalid for the given encoder's format.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .variable(let variable):
            try container.encode(variable)
        case .number(let number):
            try container.encode(number)
        }
    }
}

/// Represents a value that can be used as a operand in a `Calculation`.
public protocol CalculationOperandConvertible {
    /// A calculation operand that represents this value.
    var calculationOperand: CalculationOperand { get }
}

extension Number: CalculationOperandConvertible {
    public var calculationOperand: CalculationOperand { .number(self) }
}

extension Variable: CalculationOperandConvertible {
    public var calculationOperand: CalculationOperand { .variable(self) }
}

// MARK: - Making a Calculation

/// Makes a calculation that adds the left-hand and right-hand arguments.
/// - Parameters:
///   - lhs: An addend.
///   - rhs: An addend.
/// - Returns: An addition calculation.
public func + (lhs: CalculationOperandConvertible, rhs: CalculationOperandConvertible) -> Calculation {
    .add(rhs.calculationOperand, rhs.calculationOperand)
}

/// Makes a calculation that subtracts the right-hand from the left-hand argument.
/// - Parameters:
///   - lhs: The minuend.
///   - rhs: The subtrahend.
/// - Returns: A subtraction calculation.
public func - (lhs: CalculationOperandConvertible, rhs: CalculationOperandConvertible) -> Calculation {
    .subtract(lhs.calculationOperand, rhs.calculationOperand)
}

/// Makes a calculation the multiplies the left-hand and right-hand arguments.
/// - Parameters:
///   - lhs: A factor.
///   - rhs: A factor.
/// - Returns: A multiplication calculation.
public func * (lhs: CalculationOperandConvertible, rhs: CalculationOperandConvertible) -> Calculation {
    .multiply(lhs.calculationOperand, rhs.calculationOperand)
}

/// Makes a calculation that divides the left-hand from the right-hand argument.
/// - Parameters:
///   - lhs: The dividend.
///   - rhs: The divisor.
/// - Returns: A division calculation.
public func / (lhs: CalculationOperandConvertible, rhs: CalculationOperandConvertible) -> Calculation {
    .divide(lhs.calculationOperand, rhs.calculationOperand)
}
