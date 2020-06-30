public enum DictionaryValue {
    case string(InterpolatedText)
    case number(InterpolatedText)
    case boolean(BooleanVariable)
    case dictionary([(key: InterpolatedText, value: DictionaryValue)])
    case array([DictionaryValue])
}

extension DictionaryValue: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(KeyedValue(key: nil, value: self))
    }
}

extension DictionaryValue: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: DictionaryValue...) {
        self = .array(elements)
    }
}

extension DictionaryValue: ExpressibleByBooleanLiteral {
    public init(booleanLiteral value: Bool) {
        self = .boolean(value ? .true : .false)
    }
}

extension DictionaryValue: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (InterpolatedText, DictionaryValue)...) {
        self = .dictionary(elements)
    }
}

extension DictionaryValue: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self = .number("\(literal: value)")
    }
}

extension DictionaryValue: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) {
        self = .number("\(literal: value)")
    }
}

extension DictionaryValue: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .string(InterpolatedText(value))
    }
}

extension DictionaryValue: ExpressibleByStringInterpolation {
    public init(stringInterpolation: InterpolatedText.StringInterpolation) {
        self = .string(InterpolatedText(stringInterpolation: stringInterpolation))
    }
}
