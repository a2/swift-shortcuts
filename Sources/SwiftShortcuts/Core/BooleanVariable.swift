public enum BooleanVariable: Encodable {
    case `true`
    case `false`
    case askEachTime

    public init(_ value: Bool) {
        self = value ? .true : .false
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .true:
            try container.encode(true)
        case .false:
            try container.encode(false)
        case .askEachTime:
            try container.encode(Variable.askEachTime)
        }
    }
}

extension BooleanVariable: ExpressibleByBooleanLiteral {
    public init(booleanLiteral value: Bool) {
        self.init(value)
    }
}
