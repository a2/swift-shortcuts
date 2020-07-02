struct OuterDictionary: Encodable {
    enum CodingKeys: String, CodingKey {
        case value = "Value"
        case serializationType = "WFSerializationType"
    }

    enum ValueCodingKeys: String, CodingKey {
        case items = "WFDictionaryFieldValueItems"
    }

    let items: [KeyedValue]

    init(dictionary: [(key: Text, value: KeyedValue.EncodableValue)]) {
        self.items = dictionary.map(KeyedValue.init)
    }

    init(dictionary: [(key: Text, value: DictionaryValue)]) {
        self.items = dictionary.map(KeyedValue.init)
    }

    init(dictionary: [(key: Text, value: MultipartFormValue)]) {
        self.items = dictionary.map(KeyedValue.init)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(SerializationType.dictionaryFieldValue, forKey: .serializationType)

        var valueContainer = container.nestedContainer(keyedBy: ValueCodingKeys.self, forKey: .value)
        try valueContainer.encode(items, forKey: .items)
    }
}
