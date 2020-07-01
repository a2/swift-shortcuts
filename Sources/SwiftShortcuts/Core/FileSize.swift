enum UnitType: Int, Encodable {
    case bytes = 4
}

public enum ByteCountUnit: Int, Encodable {
    case bytes = 1
    case KB = 2
    case MB = 4
    case GB = 8
    case TB = 16
    case PB = 32
    case EB = 64
    case ZB = 128
}

public struct FileSize: Encodable {
    enum CodingKeys: String, CodingKey {
        case unitType = "Unit"
        case number = "Number"
        case unit = "ByteCountUnit"
    }

    public var number: InterpolatedText?
    public var unit: VariableValue<ByteCountUnit>

    public init(number: InterpolatedText?, unit: VariableValue<ByteCountUnit>) {
        self.number = number
        self.unit = unit
    }

    public init(number: InterpolatedText?, unit: ByteCountUnit) {
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
        try container.encode(UnitType.bytes, forKey: .unitType)
    }
}
