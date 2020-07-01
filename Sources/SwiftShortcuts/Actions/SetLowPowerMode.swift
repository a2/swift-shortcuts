public struct SetLowPowerMode: Shortcut {
    public enum Operation {
        case turnOn
        case turnOff
        case toggle
    }

    public var body: some Shortcut {
        Action(identifier: "is.workflow.actions.lowpowermode.set", parameters: Parameters(base: self))
    }

    let operation: VariableValue<Operation>

    public init(operation: VariableValue<Operation>) {
        self.operation = operation
    }

    public init(operation: Operation) {
        self.init(operation: .value(operation))
    }

    public init(_ onValue: Bool = true) {
        self.init(operation: .value(onValue ? .turnOn : .turnOff))
    }
}

extension SetLowPowerMode {
    enum OperationType: String, Encodable {
        case set
        case toggle
    }

    struct Parameters: Encodable {
        enum CodingKeys: String, CodingKey {
            case onValue = "OnValue"
            case operation = "operation"
        }

        let base: SetLowPowerMode

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            switch base.operation {
            case .value(.turnOn):
                try container.encode(OperationType.set, forKey: .operation)
                try container.encode(true, forKey: .onValue)
            case .value(.turnOff):
                try container.encode(OperationType.set, forKey: .operation)
                try container.encode(false, forKey: .onValue)
            case .value(.toggle):
                try container.encode(OperationType.toggle, forKey: .operation)
            case .variable(let variable):
                try container.encode(variable, forKey: .operation)
            }
        }
    }
}
