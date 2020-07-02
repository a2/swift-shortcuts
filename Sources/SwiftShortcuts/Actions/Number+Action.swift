extension Number: Shortcut {
    /// The contents of the shortcut.
    public var body: some Shortcut {
        Action(identifier: "is.workflow.actions.number", parameters: Parameters(base: self))
    }
}

extension Number {
    struct Parameters: Encodable {
        enum CodingKeys: String, CodingKey {
            case number = "WFNumberActionNumber"
        }

        let base: Number

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(base, forKey: .number)
        }
    }
}
