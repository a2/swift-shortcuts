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

    let items: [KeyedValue]

    init(dictionary: [(key: InterpolatedText, value: KeyedValue.EncodableValue)]) {
        self.items = dictionary.map(KeyedValue.init)
    }

    init(dictionary: [(key: InterpolatedText, value: DictionaryValue)]) {
        self.items = dictionary.map(KeyedValue.init)
    }

    init(dictionary: [(key: InterpolatedText, value: MultipartFormValue)]) {
        self.items = dictionary.map(KeyedValue.init)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(SerializationType.dictionaryFieldValue, forKey: .serializationType)

        var valueContainer = container.nestedContainer(keyedBy: ValueCodingKeys.self, forKey: .value)
        try valueContainer.encode(items, forKey: .items)
    }
}
