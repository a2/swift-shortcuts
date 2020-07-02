/// A set of predefined time format styles.
public enum TimeFormatStyle: Hashable, Encodable {
    /// Specifies no time output.
    case none

    /// Specifies short output, such as 3:30 PM.
    case short

    /// Specifies medium output, such as 3:30:32 PM.
    case medium

    /// Specifies medium output, such as 3:30:32 PM PDT.
    case long

    /// Encodes this value into the given encoder.
    /// - Parameter encoder: The encoder to write data to.
    /// - Throws: This function throws an error if any values are invalid for the given encoder's format.
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
