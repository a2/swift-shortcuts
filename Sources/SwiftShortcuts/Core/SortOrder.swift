public enum SortOrder: Encodable {
    enum CodingKeys: String, CodingKey {
        case sortOrder = "WFContentItemSortOrder"
        case sortProperty = "WFContentItemSortProperty"
    }

    case fileSize(ascending: Bool)
    case fileExtension(ascending: Bool)
    case creationDate(ascending: Bool)
    case lastModifiedDate(ascending: Bool)
    case name(ascending: Bool)
    case random

    public func encode(to encoder: Encoder) throws {
        var nestedContainer = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .fileSize(let ascending):
            try nestedContainer.encode(ascending ? "Smallest First" : "Biggest First", forKey: .sortOrder)
            try nestedContainer.encode("File Size", forKey: .sortProperty)
        case .fileExtension(let ascending):
            try nestedContainer.encode(ascending ? "A to Z" : "Z to A", forKey: .sortOrder)
            try nestedContainer.encode("File Extension", forKey: .sortProperty)
        case .creationDate(let ascending):
            try nestedContainer.encode(ascending ? "Oldest First" : "Latest First", forKey: .sortOrder)
            try nestedContainer.encode("Creation Date", forKey: .sortProperty)
        case .lastModifiedDate(let ascending):
            try nestedContainer.encode(ascending ? "Oldest First" : "Latest First", forKey: .sortOrder)
            try nestedContainer.encode("Last Modified Date", forKey: .sortProperty)
        case .name(let ascending):
            try nestedContainer.encode(ascending ? "A to Z" : "Z to A", forKey: .sortOrder)
            try nestedContainer.encode("Name", forKey: .sortProperty)
        case .random:
            try nestedContainer.encode("Random", forKey: .sortOrder)
        }
    }
}
