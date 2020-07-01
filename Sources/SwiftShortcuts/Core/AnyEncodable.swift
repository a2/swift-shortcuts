/// A type-erased wrapper for an `Encodable` object
public struct AnyEncodable: Encodable {
    private let encodeFunction: (Encoder) throws -> Void

    /// - Parameter base: The underlying value whose type to erase.
    public init<Base>(_ base: Base) where Base: Encodable {
        self.encodeFunction = base.encode(to:)
    }

    public func encode(to encoder: Encoder) throws {
        try encodeFunction(encoder)
    }
}
