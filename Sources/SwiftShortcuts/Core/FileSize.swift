enum UnitType: Int, Encodable {
    case bytes = 4
}

/// A data size represented by a floating-point number and a unit of information or variable.
public struct FileSize: Encodable {
    enum CodingKeys: String, CodingKey {
        case unitType = "Unit"
        case number = "Number"
        case unit = "ByteCountUnit"
    }

    /// A floating-point number represented as optional text. When nil, represents "anything" in the Shortcuts app.
    public var number: Text?

    /// A unit of information or a variable like `Variable.askEachTime`.
    public var unit: VariableValue<ByteCountUnit>

    /// - Parameters:
    ///   - number: A floating-point number represented as optional text. When nil, represents "anything" in the Shortcuts app.
    ///   - unit: A unit of information or a variable like `Variable.askEachTime`.
    public init(number: Text?, unit: VariableValue<ByteCountUnit>) {
        self.number = number
        self.unit = unit
    }

    /// - Parameters:
    ///   - number: A floating-point number represented as optional text. When nil, represents "anything" in the Shortcuts app.
    ///   - unit: A unit of information.
    public init(number: Text?, unit: ByteCountUnit) {
        self.number = number
        self.unit = .value(unit)
    }

    /// - Parameters:
    ///   - number: A floating-point number represented as optional text. When nil, represents "anything" in the Shortcuts app.
    ///   - unit: A variable like `Variable.askEachTime`.
    public init(number: Text?, unit: Variable) {
        self.number = number
        self.unit = .variable(unit)
    }

    /// Encodes this value into the given encoder.
    /// - Parameter encoder: The encoder to write data to.
    /// - Throws: This function throws an error if any values are invalid for the given encoder's format.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(number ?? "", forKey: .number)
        try container.encode(unit, forKey: .unit)
        try container.encode(UnitType.bytes, forKey: .unitType)
    }
}
