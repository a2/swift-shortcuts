/// Sets the device's Low Power Mode to on or off.
public struct SetLowPowerMode: Shortcut {
    /// A target state of Low Power Mode.
    public enum Operation {
        /// Turns on Low Power Mode.
        case turnOn

        /// Turns off Low Power Mode.
        case turnOff

        /// Toggles Low Power Mode.
        case toggle
    }

    /// The contents of the shortcut.
    public var body: some Shortcut {
        Action(identifier: "is.workflow.actions.lowpowermode.set", parameters: Parameters(base: self))
    }

    let operation: VariableValue<Operation>

    /// Initializes the shortcut.
    /// - Parameter operation: The target state of Low Power Mode, expressed as a variable value.
    public init(operation: VariableValue<Operation>) {
        self.operation = operation
    }

    /// Initializes the shortcut.
    /// - Parameter operation: The target state of Low Power Mode: on, off, or toggle.
    public init(operation: Operation) {
        self.init(operation: .value(operation))
    }

    /// Initializes the shortcut.
    /// - Parameter onValue: The target state of Low Power Mode, on or off.
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
