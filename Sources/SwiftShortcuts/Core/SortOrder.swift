/// Represents a method by which to sort a collecton of values.
public enum SortOrder {
    /// Sorts values by file size, either smallest first or biggest first.
    case fileSize(ascending: Bool)
    /// Sorts values by file extension, either A to Z or Z to A.
    case fileExtension(ascending: Bool)
    /// Sorts values by creation date, either oldest first or latest first.
    case creationDate(ascending: Bool)
    /// Sorts values by last modified date, either oldest first or latest first.
    case lastModifiedDate(ascending: Bool)
    /// Sorts values by name, either A to Z or Z to A.
    case name(ascending: Bool)
    /// A sort order that shuffles values.
    case random
}

extension SortOrder: Encodable {
    enum CodingKeys: String, CodingKey {
        case sortOrder = "WFContentItemSortOrder"
        case sortProperty = "WFContentItemSortProperty"
    }

    /// Encodes this value into the given encoder.
    /// - Parameter encoder: The encoder to write data to.
    /// - Throws: This function throws an error if any values are invalid for the given encoder's format.
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
