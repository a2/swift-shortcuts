public struct URLEncode: Shortcut {
    public enum Operation {
        case encode
        case decode
        case askEachTime
    }

    let operation: Operation
    let input: Variable

    public var body: some Shortcut {
        Action(identifier: "is.workflow.actions.urlencode", parameters: Parameters(base: self))
    }

    public init(input: Variable, operation: Operation = .encode) {
        self.operation = operation
        self.input = input
    }
}

extension URLEncode {
    struct Parameters: Encodable {
        enum CodingKeys: String, CodingKey {
            case input = "WFInput"
            case operation = "WFEncodeMode"
        }

        let base: URLEncode

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(base.input, forKey: .input)

            switch base.operation {
            case .encode:
                try container.encode("Encode", forKey: .operation)
            case .decode:
                try container.encode("Decode", forKey: .operation)
            case .askEachTime:
                try container.encode(Variable.askEachTime, forKey: .operation)
            }
        }
    }
}
