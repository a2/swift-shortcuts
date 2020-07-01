public struct URLEncode: Shortcut {
    public enum Operation: String, Encodable {
        case encode = "Encode"
        case decode = "Decode"
    }

    let input: InterpolatedText
    let operation: VariableValue<Operation>

    public var body: some Shortcut {
        Action(identifier: "is.workflow.actions.urlencode", parameters: Parameters(base: self))
    }

    public init(input: InterpolatedText, operation: VariableValue<Operation>) {
        self.operation = operation
        self.input = input
    }

    public init(input: InterpolatedText, operation: Operation = .encode) {
        self.init(input: input, operation: .value(operation))
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
            try container.encode(base.operation, forKey: .operation)
        }
    }
}
