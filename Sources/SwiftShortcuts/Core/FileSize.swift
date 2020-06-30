enum UnitType: Int, Encodable {
    case bytes = 4
}

public enum ByteCountUnit: Encodable {
    case bytes
    case KB
    case MB
    case GB
    case TB
    case PB
    case EB
    case ZB
    case askEachTime

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .bytes:
            try container.encode(1)
        case .KB:
            try container.encode(2)
        case .MB:
            try container.encode(4)
        case .GB:
            try container.encode(8)
        case .TB:
            try container.encode(16)
        case .PB:
            try container.encode(32)
        case .EB:
            try container.encode(64)
        case .ZB:
            try container.encode(128)
        case .askEachTime:
            try container.encode(Variable.askEachTime)
        }
    }
}

public struct FileSize: Encodable {
    enum CodingKeys: String, CodingKey {
        case unitType = "Unit"
        case number = "Number"
        case unit = "ByteCountUnit"
    }

    public var number: InterpolatedText?
    public var unit: ByteCountUnit

    public init(number: InterpolatedText?, unit: ByteCountUnit) {
        self.number = number
        self.unit = unit
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(number ?? "", forKey: .number)
        try container.encode(unit, forKey: .unit)
        try container.encode(UnitType.bytes, forKey: .unitType)
    }
}
