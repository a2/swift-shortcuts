public struct Calculate: Shortcut {
    let calculation: Calculation

    public var body: some Shortcut {
        Action(identifier: "is.workflow.actions.math", parameters: Parameters(base: self))
    }

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

        enum OperandNames: String, Encodable {
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
                try container.encode(OperandNames.add, forKey: .operation)
                try container.encode(rhs, forKey: .rhs)
            case .subtract(let lhs, let rhs):
                try container.encode(lhs, forKey: .lhs)
                try container.encode(OperandNames.subtract, forKey: .operation)
                try container.encode(rhs, forKey: .rhs)
            case .multiply(let lhs, let rhs):
                try container.encode(lhs, forKey: .lhs)
                try container.encode(OperandNames.multiply, forKey: .operation)
                try container.encode(rhs, forKey: .rhs)
            case .divide(let lhs, let rhs):
                try container.encode(lhs, forKey: .lhs)
                try container.encode(OperandNames.divide, forKey: .operation)
                try container.encode(rhs, forKey: .rhs)
            case .askEachTime(let lhs, let rhs):
                try container.encode(lhs, forKey: .lhs)
                try container.encode(Variable.askEachTime, forKey: .operation)
                try container.encodeIfPresent(rhs, forKey: .rhs)
            }
        }
    }
}

public enum Calculation {
    case add(CalculationOperand, CalculationOperand)
    case subtract(CalculationOperand, CalculationOperand)
    case multiply(CalculationOperand, CalculationOperand)
    case divide(CalculationOperand, CalculationOperand)
    case askEachTime(CalculationOperand, CalculationOperand?)
}

public enum CalculationOperand: Encodable {
    case variable(Variable)
    case number(Number)

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

public protocol CalculationOperandConvertible {
    var calculationOperand: CalculationOperand { get }
}

extension Number: CalculationOperandConvertible {
    public var calculationOperand: CalculationOperand { .number(self) }
}

extension Variable: CalculationOperandConvertible {
    public var calculationOperand: CalculationOperand { .variable(self) }
}

// MARK: - Making a Calculation

public func + (lhs: CalculationOperandConvertible, rhs: CalculationOperandConvertible) -> Calculation {
    .add(rhs.calculationOperand, rhs.calculationOperand)
}

public func - (lhs: CalculationOperandConvertible, rhs: CalculationOperandConvertible) -> Calculation {
    .subtract(lhs.calculationOperand, rhs.calculationOperand)
}

public func * (lhs: CalculationOperandConvertible, rhs: CalculationOperandConvertible) -> Calculation {
    .multiply(lhs.calculationOperand, rhs.calculationOperand)
}

public func / (lhs: CalculationOperandConvertible, rhs: CalculationOperandConvertible) -> Calculation {
    .divide(lhs.calculationOperand, rhs.calculationOperand)
}
