public struct HealthSampleValue {
    public var magnitude: Text
    public var unit: HealthSampleUnit

    public init(magnitude: Text, unit: HealthSampleUnit) {
        self.magnitude = magnitude
        self.unit = unit
    }

    public init(magnitude: Variable, unit: HealthSampleUnit) {
        self.magnitude = "\(magnitude)"
        self.unit = unit
    }
}

extension HealthSampleValue: Encodable {
    enum CodingKeys: String, CodingKey {
        case value = "Value"
        case serializationType = "WFSerializationType"
    }

    enum ValueCodingKeys: String, CodingKey {
        case magnitude = "Magnitude"
        case unit = "Unit"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(SerializationType.quantityFieldValue, forKey: .serializationType)

        var valueContainer = container.nestedContainer(keyedBy: ValueCodingKeys.self, forKey: .value)
        try valueContainer.encode(unit, forKey: .unit)

        if magnitude.string.count == 1 && magnitude.variablesByRange.count == 1 {
            let variable = magnitude.variablesByRange[magnitude.variablesByRange.startIndex].value
            try valueContainer.encode(variable.value, forKey: .magnitude)
        } else {
            try valueContainer.encode(magnitude, forKey: .magnitude)
        }
    }
}
