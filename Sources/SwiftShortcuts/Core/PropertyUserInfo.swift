// TODO: Make this internal

/// Represents `PropertyName`-dependent information that the Shortcuts app expects for certain properties.
public enum PropertyUserInfo: Hashable, Encodable {
    /// File size.
    case fileSize

    /// File extension.
    case fileExtension

    /// A specified number.
    case number(Number)

    /// Encodes this value into the given encoder.
    /// - Parameter encoder: The encoder to write data to.
    /// - Throws: This function throws an error if any values are invalid for the given encoder's format.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .fileSize:
            try container.encode("WFFileSizeProperty")
        case .fileExtension:
            try container.encode("WFFileExtensionProperty")
        case .number(let number):
            try container.encode(number)
        }
    }
}
