import Foundation

public enum DictionaryValue {
    case string(InterpolatedText)
    case number(Number)
    case boolean(Bool)
    case dictionary([(key: InterpolatedText, value: DictionaryValue)])
    case array([DictionaryValue])
}

extension DictionaryValue: Encodable {
    enum ItemType: Int, Encodable {
        case string = 0
        case dictionary = 1
        case array = 2
        case number = 3
        case boolean = 4
    }

    enum CodingKeys: String, CodingKey {
        case itemType = "WFItemType"
        case value = "WFValue"
    }

    enum NestedCodingKeys: String, CodingKey {
        case serializationType = "WFSerializationType"
        case value = "Value"
    }

    enum DictionaryCodingKeys: String, CodingKey {
        case value = "WFDictionaryFieldValueItems"
    }

    enum SerializationType: String, Encodable {
        case arrayParameterState = "WFArrayParameterState"
        case dictionaryFieldValue = "WFDictionaryFieldValue"
        case numberSubstitutableState = "WFNumberSubstitutableState"
    }

    struct KeyValue: Encodable {
        enum CodingKeys: String, CodingKey {
            case key = "WFKey"
        }

        let key: InterpolatedText
        let value: DictionaryValue

        func encode(to encoder: Encoder) throws {
            try value.encode(to: encoder)

            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(key, forKey: .key)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .string(let interpolatedText):
            try container.encode(ItemType.string, forKey: .itemType)
            try container.encode(interpolatedText, forKey: .value)
        case .number(let number):
            try container.encode(ItemType.number, forKey: .itemType)
            try container.encode(InterpolatedText("\(literal: number)"), forKey: .value)
        case .boolean(let bool):
            try container.encode(ItemType.boolean, forKey: .itemType)

            var nestedContainer = container.nestedContainer(keyedBy: NestedCodingKeys.self, forKey: .value)
            try nestedContainer.encode(SerializationType.numberSubstitutableState, forKey: .serializationType)
            try nestedContainer.encode(bool, forKey: .value)
        case .array(let array):
            try container.encode(ItemType.array, forKey: .itemType)

            var nestedContainer = container.nestedContainer(keyedBy: NestedCodingKeys.self, forKey: .value)
            try nestedContainer.encode(SerializationType.arrayParameterState, forKey: .serializationType)
            try nestedContainer.encode(array, forKey: .value)
        case .dictionary(let dictionary):
            try container.encode(ItemType.dictionary, forKey: .itemType)

            var nestedContainer = container.nestedContainer(keyedBy: NestedCodingKeys.self, forKey: .value)
            try nestedContainer.encode(SerializationType.dictionaryFieldValue, forKey: .serializationType)
            try nestedContainer.encode(dictionary.map(KeyValue.init), forKey: .value)
        }
    }
}

extension DictionaryValue: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: DictionaryValue...) {
        self = .array(elements)
    }
}

extension DictionaryValue: ExpressibleByBooleanLiteral {
    public init(booleanLiteral value: Bool) {
        self = .boolean(value)
    }
}

extension DictionaryValue: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (InterpolatedText, DictionaryValue)...) {
        self = .dictionary(elements)
    }
}

extension DictionaryValue: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self = .number(Number(value))
    }
}

extension DictionaryValue: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) {
        self = .number(Number(value))
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

public struct GetDictionary: Shortcut {
    let value: [(key: InterpolatedText, value: DictionaryValue)]

    public var body: some Shortcut {
        Action(identifier: "is.workflow.actions.dictionary", parameters: Parameters(base: self))
    }

    public init(_ value: KeyValuePairs<InterpolatedText, DictionaryValue>) {
        self.value = Array(value)
    }
}

extension GetDictionary {
    struct Parameters: Encodable {
        enum CodingKeys: String, CodingKey {
            case items = "WFItems"
        }

        let base: GetDictionary

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(DictionaryValue.dictionary(base.value), forKey: .items)
        }
    }
}
