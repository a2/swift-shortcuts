/// The type of a Health sample, such as "Water" or "Vitamin C".
public struct HealthSampleType<MeasurementType>: RawRepresentable, Encodable where MeasurementType: HealthMeasurementType {
    /// The corresponding value of the raw type.
    public let rawValue: String

    /// Creates a new instance with the specified raw value.
    /// - Parameter rawValue: The raw value to use for the new instance.
    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    /// Creates a new instance with the specified raw value.
    /// - Parameter rawValue: The raw value to use for the new instance.
    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }
    
    /// Encodes this value into the given encoder.
    /// - Parameter encoder: The encoder to write data to.
    /// - Throws: This function throws an error if any values are invalid for the given encoder's format.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}

extension HealthSampleType where MeasurementType == HealthMeasurement.Count {
    /// The "Steps" sample type in the Health app.
    public static var steps: HealthSampleType { HealthSampleType("Steps") }
}

extension HealthSampleType where MeasurementType == HealthMeasurement.Liquid {
    /// The "Water" sample type in the Health app.
    public static var water: HealthSampleType { HealthSampleType("Water") }
}
