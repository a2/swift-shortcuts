/// Encodes or decodes text passed into the action to be suitable for inclusion in a URL by adding or removing percent escapes when appropriate.
///
/// **Input:** Text
///
/// **Result:** Text
public struct URLEncode: Shortcut {
    /// Controls whether percent escapes are added or removed.
    public enum Operation: String, Encodable {
        /// Adds percent escapes.
        case encode = "Encode"

        /// Removes percent escapes.
        case decode = "Decode"
    }

    let input: Text
    let operation: VariableValue<Operation>

    /// The contents of the shortcut.
    public var body: some Shortcut {
        Action(identifier: "is.workflow.actions.urlencode", parameters: Parameters(base: self))
    }

    /// Initializes the shortcut.
    /// - Parameters:
    ///   - input: The input text to encode or decode.
    ///   - operation: The operation to apply to the text, either encode or decode.
    public init(input: Text, operation: VariableValue<Operation>) {
        self.operation = operation
        self.input = input
    }

    /// Initializes the shortcut.
    /// - Parameters:
    ///   - input: The input text to encode or decode.
    ///   - operation: The operation to apply to the text, either encode or decode.
    public init(input: Text, operation: Operation = .encode) {
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
