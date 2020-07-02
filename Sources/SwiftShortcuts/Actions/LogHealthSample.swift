import Foundation

public struct LogHealthSample: Shortcut {
    let type: HealthSampleType
    let value: HealthSampleValue
    let date: Text

    public var body: some Shortcut {
        Action(identifier: "is.workflow.actions.health.quantity.log", parameters: Parameters(base: self))
    }

    public init(type: HealthSampleType, value: HealthSampleValue, date: Text = "") {
        self.type = type
        self.value = value
        self.date = date
    }
}

extension LogHealthSample {
    struct Parameters: Encodable {
        enum CodingKeys: String, CodingKey {
            case sampleType = "WFQuantitySampleType"
            case sampleDate = "WFQuantitySampleDate"
            case sampleQuantity = "WFQuantitySampleQuantity"
            case sampleAdditionalQuantity = "WFQuantitySampleAdditionalQuantity" // ?
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
