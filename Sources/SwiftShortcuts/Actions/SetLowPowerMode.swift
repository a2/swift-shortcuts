public struct SetLowPowerMode: Action {
    public enum Operation {
        case set(Bool)
        case toggle
    }

    public var body: some Action {
        ActionStep(identifier: "is.workflow.actions.lowpowermode.set", parameters: Parameters(base: self))
    }

    let operation: Operation

    public init(operation: Operation) {
        self.operation = operation
    }

    public init(_ onValue: Bool = true) {
        self.operation = .set(onValue)
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
            case .set(let onValue):
                try container.encode(OperationType.set, forKey: .operation)
                try container.encode(onValue, forKey: .onValue)
            case .toggle:
                try container.encode(OperationType.toggle, forKey: .operation)
            }
        }
    }
}
