public struct TimeSpanValue: Encodable {
    enum CodingKeys: String, CodingKey {
        case number = "Number"
        case unit = "Unit"
    }

    public var number: InterpolatedText?
    public var unit: VariableValue<TimeUnit>

    public init(number: InterpolatedText?, unit: VariableValue<TimeUnit>) {
        self.number = number
        self.unit = unit
    }

    public init(number: InterpolatedText?, unit: TimeUnit) {
        self.number = number
        self.unit = .value(unit)
    }

    public init(number: InterpolatedText?, unit: Variable) {
        self.number = number
        self.unit = .variable(unit)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(number ?? "", forKey: .number)
        try container.encode(unit, forKey: .unit)
    }
}
