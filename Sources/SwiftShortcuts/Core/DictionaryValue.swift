import Foundation

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
        try container.encode(KeyedDictionaryValue(key: nil, value: self))
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

struct KeyedDictionaryValue: Encodable {
    enum ItemType: Int, Encodable {
        case string = 0
        case dictionary = 1
        case array = 2
        case number = 3
        case boolean = 4
    }

    enum CodingKeys: String, CodingKey {
        case key = "WFKey"
        case itemType = "WFItemType"
        case value = "WFValue"
    }

    enum NestedCodingKeys: String, CodingKey {
        case serializationType = "WFSerializationType"
        case value = "Value"
    }

    enum SerializationType: String, Encodable {
        case arrayParameterState = "WFArrayParameterState"
        case dictionaryFieldValue = "WFDictionaryFieldValue"
        case numberSubstitutableState = "WFNumberSubstitutableState"
    }

    let key: InterpolatedText?
    let value: DictionaryValue
    var encodesPlainStringsAsInterpolatedText = true

    init(key: InterpolatedText?, value: DictionaryValue) {
        self.key = key
        self.value = value
    }

    func encode(to encoder: Encoder) throws {
        precondition(key == nil || encodesPlainStringsAsInterpolatedText)

        if var key = key {
            key.allowsEncodingAsPlainString = false

            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(key, forKey: .key)
        }

        switch value {
        case .string(var interpolatedText):
            if !encodesPlainStringsAsInterpolatedText && interpolatedText.variablesByRange.isEmpty {
                var container = encoder.singleValueContainer()
                try container.encode(interpolatedText)
                return
            }

            interpolatedText.allowsEncodingAsPlainString = false

            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(ItemType.string, forKey: .itemType)
            try container.encode(interpolatedText, forKey: .value)
        case .number(var interpolatedText):
            interpolatedText.allowsEncodingAsPlainString = false

            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(ItemType.number, forKey: .itemType)
            try container.encode(interpolatedText, forKey: .value)
        case .boolean(let bool):
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(ItemType.boolean, forKey: .itemType)

            var nestedContainer = container.nestedContainer(keyedBy: NestedCodingKeys.self, forKey: .value)
            try nestedContainer.encode(bool, forKey: .value)
            try nestedContainer.encode(SerializationType.numberSubstitutableState, forKey: .serializationType)
        case .array(let array):
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(ItemType.array, forKey: .itemType)

            var nestedContainer = container.nestedContainer(keyedBy: NestedCodingKeys.self, forKey: .value)
            try nestedContainer.encode(SerializationType.arrayParameterState, forKey: .serializationType)

            var unkeyedContainer = nestedContainer.nestedUnkeyedContainer(forKey: .value)
            for value in array {
                var keyedValue = KeyedDictionaryValue(key: nil, value: value)
                keyedValue.encodesPlainStringsAsInterpolatedText = false
                try unkeyedContainer.encode(keyedValue)
            }
        case .dictionary(let dictionary):
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(ItemType.dictionary, forKey: .itemType)

            var nestedContainer = container.nestedContainer(keyedBy: NestedCodingKeys.self, forKey: .value)
            try nestedContainer.encode(OuterDictionary(dictionary: dictionary), forKey: .value)
            try nestedContainer.encode(SerializationType.dictionaryFieldValue, forKey: .serializationType)
        }
    }
}

struct OuterDictionary: Encodable {
    enum CodingKeys: String, CodingKey {
        case value = "Value"
        case serializationType = "WFSerializationType"
    }

    enum ValueCodingKeys: String, CodingKey {
        case items = "WFDictionaryFieldValueItems"
    }

    enum SerializationType: String, Encodable {
        case dictionaryFieldValue = "WFDictionaryFieldValue"
    }

    let dictionary: [(key: InterpolatedText, value: DictionaryValue)]

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(SerializationType.dictionaryFieldValue, forKey: .serializationType)

        var valueContainer = container.nestedContainer(keyedBy: ValueCodingKeys.self, forKey: .value)
        try valueContainer.encode(dictionary.map(KeyedDictionaryValue.init), forKey: .items)
    }
}
