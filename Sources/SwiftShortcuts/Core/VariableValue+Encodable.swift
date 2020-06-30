extension VariableValue: Encodable where Value: Encodable {
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
