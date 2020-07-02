struct AnyEncodable: Encodable {
    private let encodeFunction: (Encoder) throws -> Void

    init<Base>(_ base: Base) where Base: Encodable {
        self.encodeFunction = base.encode(to:)
    }

    func encode(to encoder: Encoder) throws {
        try encodeFunction(encoder)
    }
}
