public struct AnyEncodable: Encodable {
    private let encodeFunction: (Encoder) throws -> Void

    public init<Base>(_ base: Base) where Base: Encodable {
        self.encodeFunction = base.encode(to:)
    }

    public func encode(to encoder: Encoder) throws {
        try encodeFunction(encoder)
    }
}

