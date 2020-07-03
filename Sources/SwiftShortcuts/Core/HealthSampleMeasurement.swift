/// A value that can be logged to the Health app.
///
/// - See Also: `LogHealthSample`
public struct HealthSampleMeasurement<MeasurementType> where MeasurementType: HealthMeasurementType {
    /// The size of the Health sample, represented as `Text`.
    public var magnitude: Text

    /// The unit of the Health sample.
    public var unit: HealthSampleUnit<MeasurementType>

    /// Initializes the value.
    /// - Parameters:
    ///   - magnitude: The size of the health sample.
    ///   - unit: The unit of the health sample.
    public init(magnitude: Text, unit: HealthSampleUnit<MeasurementType>) {
        self.magnitude = magnitude
        self.unit = unit
    }

    /// Initializes the value.
    /// - Parameters:
    ///   - magnitude: The size of the health sample, as a `Variable`.
    ///   - unit: The unit of the health sample.
    public init(magnitude: Variable, unit: HealthSampleUnit<MeasurementType>) {
        self.magnitude = "\(magnitude)"
        self.unit = unit
    }
}

extension HealthSampleMeasurement: Encodable {
    enum CodingKeys: String, CodingKey {
        case value = "Value"
        case serializationType = "WFSerializationType"
    }

    enum ValueCodingKeys: String, CodingKey {
        case magnitude = "Magnitude"
        case unit = "Unit"
    }

    /// Encodes this value into the given encoder.
    /// - Parameter encoder: The encoder to write data to.
    /// - Throws: This function throws an error if any values are invalid for the given encoder's format.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(SerializationType.quantityFieldValue, forKey: .serializationType)

        var valueContainer = container.nestedContainer(keyedBy: ValueCodingKeys.self, forKey: .value)
        try valueContainer.encode(unit, forKey: .unit)

        if let variable = magnitude.singleVariable {
            try valueContainer.encode(variable.value, forKey: .magnitude)
        } else {
            try valueContainer.encode(magnitude, forKey: .magnitude)
        }
    }
}
