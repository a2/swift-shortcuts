extension VariableValue: Encodable where Value: Encodable {
    /// Encodes this value into the given encoder.
    /// - Parameter encoder: The encoder to write data to.
    /// - Throws: This function throws an error if any values are invalid for the given encoder's format.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .value(let value):
            try container.encode(value)
        case .variable(let variable):
            try container.encode(variable)
        }
    }
}
