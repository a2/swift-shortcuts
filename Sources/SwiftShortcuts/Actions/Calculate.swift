public struct Calculate: Shortcut {
    let calculation: Calculation

    public var body: some Shortcut {
        Action(identifier: "is.workflow.actions.math", parameters: Parameters(base: self))
    }

    public init(_ calculation: Calculation) {
        self.calculation = calculation
    }

    public init(lhs: Number, operation: Calculation.Operation, rhs: Number) {
        self.calculation = Calculation(lhs: .number(lhs), operation: operation, rhs: .number(rhs))
    }

    public init(lhs: Variable, operation: Calculation.Operation, rhs: Number) {
        self.calculation = Calculation(lhs: .variable(lhs), operation: operation, rhs: .number(rhs))
    }

    public init(lhs: Number, operation: Calculation.Operation, rhs: Variable) {
        self.calculation = Calculation(lhs: .number(lhs), operation: operation, rhs: .variable(rhs))
    }

    public init(lhs: Variable, operation: Calculation.Operation, rhs: Variable) {
        self.calculation = Calculation(lhs: .variable(lhs), operation: operation, rhs: .variable(rhs))
    }
}

extension Calculate {
    struct Parameters: Encodable {
        enum CodingKeys: String, CodingKey {
            case lhs = "WFInput"
            case operation = "WFMathOperation"
            case rhs = "WFMathOperand"
        }

        let base: Calculate

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(base.calculation.lhs, forKey: .lhs)
            try container.encode(base.calculation.operation, forKey: .operation)
            try container.encode(base.calculation.rhs, forKey: .rhs)
        }
    }
}

public struct Calculation {
    enum Operand {
        case variable(Variable)
        case number(Number)
    }

    public enum Operation {
        case add
        case subtract
        case multiply
        case divide
        case askEachTime
    }

    let lhs: Operand
    let operation: Operation
    let rhs: Operand
}

extension Calculation.Operand: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .variable(let variable):
            try container.encode(variable)
        case .number(let number):
            try container.encode(number)
        }
    }
}

extension Calculation.Operation: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .add:
            try container.encode("+")
        case .subtract:
            try container.encode("-")
        case .multiply:
            try container.encode("×")
        case .divide:
            try container.encode("÷")
        case .askEachTime:
            try container.encode(Variable.askEachTime)
        }
    }
}

// MARK: - Add

public func + (lhs: Number, rhs: Number) -> Calculation {
    Calculation(lhs: .number(lhs), operation: .add, rhs: .number(rhs))
}

public func + (lhs: Variable, rhs: Number) -> Calculation {
    Calculation(lhs: .variable(lhs), operation: .add, rhs: .number(rhs))
}

public func + (lhs: Number, rhs: Variable) -> Calculation {
    Calculation(lhs: .number(lhs), operation: .add, rhs: .variable(rhs))
}

public func + (lhs: Variable, rhs: Variable) -> Calculation {
    Calculation(lhs: .variable(lhs), operation: .add, rhs: .variable(rhs))
}

// MARK: - Subtract

public func - (lhs: Number, rhs: Number) -> Calculation {
    Calculation(lhs: .number(lhs), operation: .add, rhs: .number(rhs))
}

public func - (lhs: Variable, rhs: Number) -> Calculation {
    Calculation(lhs: .variable(lhs), operation: .subtract, rhs: .number(rhs))
}

public func - (lhs: Number, rhs: Variable) -> Calculation {
    Calculation(lhs: .number(lhs), operation: .subtract, rhs: .variable(rhs))
}

public func - (lhs: Variable, rhs: Variable) -> Calculation {
    Calculation(lhs: .variable(lhs), operation: .subtract, rhs: .variable(rhs))
}

// MARK: - Multiply

public func * (lhs: Number, rhs: Number) -> Calculation {
    Calculation(lhs: .number(lhs), operation: .multiply, rhs: .number(rhs))
}

public func * (lhs: Variable, rhs: Number) -> Calculation {
    Calculation(lhs: .variable(lhs), operation: .multiply, rhs: .number(rhs))
}

public func * (lhs: Number, rhs: Variable) -> Calculation {
    Calculation(lhs: .number(lhs), operation: .multiply, rhs: .variable(rhs))
}

public func * (lhs: Variable, rhs: Variable) -> Calculation {
    Calculation(lhs: .variable(lhs), operation: .multiply, rhs: .variable(rhs))
}

// MARK: - Divide

public func / (lhs: Number, rhs: Number) -> Calculation {
    Calculation(lhs: .number(lhs), operation: .divide, rhs: .number(rhs))
}

public func / (lhs: Variable, rhs: Number) -> Calculation {
    Calculation(lhs: .variable(lhs), operation: .divide, rhs: .number(rhs))
}

public func / (lhs: Number, rhs: Variable) -> Calculation {
    Calculation(lhs: .number(lhs), operation: .divide, rhs: .variable(rhs))
}

public func / (lhs: Variable, rhs: Variable) -> Calculation {
    Calculation(lhs: .variable(lhs), operation: .divide, rhs: .variable(rhs))
}
