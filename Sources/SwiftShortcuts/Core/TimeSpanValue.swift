/// A time duration represented by a floating-point number and a time unit or variable.
public struct TimeSpanValue: Encodable {
    enum CodingKeys: String, CodingKey {
        case number = "Number"
        case unit = "Unit"
    }

    /// A floating-point number represented as optional text. When nil, represents "anything" in the Shortcuts app.
    public var number: Text?

    /// A time unit or a variable like `Variable.askEachTime`.
    public var unit: VariableValue<TimeUnit>

    /// - Parameters:
    ///   - number: A floating-point number represented as optional text. When nil, represents "anything" in the Shortcuts app.
    ///   - unit: A time unit or a variable like `Variable.askEachTime`.
    public init(number: Text?, unit: VariableValue<TimeUnit>) {
        self.number = number
        self.unit = unit
    }

    /// - Parameters:
    ///   - number: A floating-point number represented as optional text. When nil, represents "anything" in the Shortcuts app.
    ///   - unit: A time unit.
    public init(number: Text?, unit: TimeUnit) {
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
    }
}
