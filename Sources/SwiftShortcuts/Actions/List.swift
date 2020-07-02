public struct List: Shortcut {
    let items: [Text]

    public var body: some Shortcut {
        Action(identifier: "is.workflow.actions.list", parameters: Parameters(base: self))
    }

    public init(_ items: [Text]) {
        self.items = items
    }

    public init(_ items: Text...) {
        self.items = items
    }
}

extension List {
    struct Parameters: Encodable {
        enum CodingKeys: String, CodingKey {
            case items = "WFItems"
        }

        let base: List

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(base.items, forKey: .items)
        }
    }
}
