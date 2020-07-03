import Foundation

/// Adds a data point into the Health app. You can log anything that the Health app supports, including your weight, steps taken, running distance, caloric intake and more.
///
/// **Result:** Health sample
public struct LogHealthSample<MeasurementType>: Shortcut where MeasurementType: HealthMeasurementType {
    let type: HealthSampleType<MeasurementType>
    let value: HealthSampleMeasurement<MeasurementType>
    let date: Text

    /// The contents of the shortcut.
    public var body: some Shortcut {
        Action(identifier: "is.workflow.actions.health.quantity.log", parameters: Parameters(base: self))
    }

    /// Initializes the shortcut.
    /// - Parameters:
    ///   - type: The type of health sample to log.
    ///   - value: The value of the health sample.
    ///   - date: The date and time of the data point. The current date will be used if you don't provide a date.
    public init(type: HealthSampleType<MeasurementType>, value: HealthSampleMeasurement<MeasurementType>, date: Text = "") {
        self.type = type
        self.value = value
        self.date = date
    }

    /// Initializes the shortcut.
    /// - Parameters:
    ///   - type: The type of health sample to log.
    ///   - magnitude: The size of the health sample.
    ///   - unit: The unit of the health sample.
    ///   - date: The date and time of the data point. The current date will be used if you don't provide a date.
    public init(type: HealthSampleType<MeasurementType>, magnitude: Text, unit: HealthSampleUnit<MeasurementType>, date: Text = "") {
        self.type = type
        self.value = HealthSampleMeasurement(magnitude: magnitude, unit: unit)
        self.date = date
    }

    /// Initializes the shortcut.
    /// - Parameters:
    ///   - type: The type of health sample to log.
    ///   - magnitude: The size of the health sample, as a `Variable`.
    ///   - unit: The unit of the health sample.
    ///   - date: The date and time of the data point. The current date will be used if you don't provide a date.
    public init(type: HealthSampleType<MeasurementType>, magnitude: Variable, unit: HealthSampleUnit<MeasurementType>, date: Text = "") {
        self.type = type
        self.value = HealthSampleMeasurement(magnitude: magnitude, unit: unit)
        self.date = date
    }
}

extension LogHealthSample {
    struct Parameters: Encodable {
        enum CodingKeys: String, CodingKey {
            case sampleType = "WFQuantitySampleType"
            case sampleDate = "WFQuantitySampleDate"
            case sampleQuantity = "WFQuantitySampleQuantity"
        }

        let base: LogHealthSample

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(base.type, forKey: .sampleType)
            try container.encode(base.value, forKey: .sampleQuantity)
            try container.encode(base.date, forKey: .sampleDate)
        }
    }
}
