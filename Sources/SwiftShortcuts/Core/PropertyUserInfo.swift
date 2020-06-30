public enum PropertyUserInfo: Hashable, Encodable {
    case fileSize
    case fileExtension
    case number(Number)

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
