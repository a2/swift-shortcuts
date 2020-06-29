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
