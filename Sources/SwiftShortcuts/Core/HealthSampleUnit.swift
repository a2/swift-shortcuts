public struct HealthSampleUnit: RawRepresentable, Encodable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}

extension HealthSampleUnit {
    public static var liters: HealthSampleUnit { HealthSampleUnit("L") }
}
