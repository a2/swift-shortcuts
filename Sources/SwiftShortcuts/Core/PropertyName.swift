/// The name of a property that can be fetched from a `Variable`.
public struct PropertyName: RawRepresentable, Hashable, Encodable {
    /// The corresponding value of the raw type.
    public let rawValue: String

    /// Creates a new instance with the specified raw value.
    /// - Parameter rawValue: The raw value to use for the new instance.
    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    /// Creates a new instance with the specified raw value.
    /// - Parameter rawValue: The raw value to use for the new instance.
    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }

    /// The "File Size" property.
    public static var fileSize: PropertyName { PropertyName("File Size") }

    /// The "File Extension" property.
    public static var fileExtension: PropertyName { PropertyName("File Extension") }

    /// The "Name" property.
    public static var name: PropertyName { PropertyName("Name") }

    /// Encodes this value into the given encoder.
    /// - Parameter encoder: The encoder to write data to.
    /// - Throws: This function throws an error if any values are invalid for the given encoder's format.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}
