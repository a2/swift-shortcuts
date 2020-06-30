struct KeyedValue: Encodable {
    enum ItemType: Int, Encodable {
        case string = 0
        case dictionary = 1
        case array = 2
        case number = 3
        case boolean = 4
        case file = 5
    }

    enum EncodableValue {
        case string(InterpolatedText)
        case number(InterpolatedText)
        case boolean(VariableValue<Bool>)
        case dictionary([(key: InterpolatedText, value: DictionaryValue)])
        case array([DictionaryValue])
        case file(Variable)
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

    let key: InterpolatedText?
    let value: EncodableValue
    var encodesPlainStringsAsInterpolatedText = true

    init(key: InterpolatedText?, value: EncodableValue) {
        self.key = key
        self.value = value
    }

    init(key: InterpolatedText?, value: DictionaryValue) {
        self.key = key

        switch value {
        case .string(let value):
            self.value = .string(value)
        case .number(let value):
            self.value = .number(value)
        case .boolean(let value):
            self.value = .boolean(value)
        case .dictionary(let value):
            self.value = .dictionary(value)
        case .array(let value):
            self.value = .array(value)
        }
    }

    init(key: InterpolatedText?, value: MultipartFormValue) {
        self.key = key

        switch value {
        case .string(let value):
            self.value = .string(value)
        case .file(let value):
            self.value = .file(value)
        }
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
                var keyedValue = KeyedValue(key: nil, value: value)
                keyedValue.encodesPlainStringsAsInterpolatedText = false
                try unkeyedContainer.encode(keyedValue)
            }
        case .dictionary(let dictionary):
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(ItemType.dictionary, forKey: .itemType)

            var nestedContainer = container.nestedContainer(keyedBy: NestedCodingKeys.self, forKey: .value)
            try nestedContainer.encode(OuterDictionary(dictionary: dictionary), forKey: .value)
            try nestedContainer.encode(SerializationType.dictionaryFieldValue, forKey: .serializationType)
        case .file(let variable):
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(ItemType.file, forKey: .itemType)

            var nestedContainer = container.nestedContainer(keyedBy: NestedCodingKeys.self, forKey: .value)
            try nestedContainer.encode(variable, forKey: .value)
            try nestedContainer.encode(SerializationType.tokenAttachmentParameterState, forKey: .serializationType)
        }
    }
}
