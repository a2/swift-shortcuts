public struct PropertyName: RawRepresentable, Hashable, Encodable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }

    public static var fileSize: PropertyName { PropertyName("File Size") }
    public static var fileExtension: PropertyName { PropertyName("File Extension") }
    public static var name: PropertyName { PropertyName("Name") }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}
