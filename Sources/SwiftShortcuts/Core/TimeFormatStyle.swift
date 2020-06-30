public enum TimeFormatStyle: Hashable, Encodable {
    case none
    case short
    case medium
    case long

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .none:
            try container.encode("None")
        case .short:
            try container.encode("Short")
        case .medium:
            try container.encode("Medium")
        case .long:
            try container.encode("Long")
        }
    }
}
