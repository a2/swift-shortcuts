/// A protocol that all phantom measurement types under `HealthMeasurement` should conform to.
public protocol HealthMeasurementType {}

/// A enumeration used for namespacing health measurement types.
public enum HealthMeasurement {}

extension HealthMeasurement {
    /// A phantom type for countable measurements.
    public enum Count: HealthMeasurementType {}

    /// A phantom type for liquid-type measurements.
    public enum Liquid: HealthMeasurementType {}
}
