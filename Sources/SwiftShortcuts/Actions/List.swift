/// Allows you to specify a list of items.
///
/// **Result:** Text
public struct List: Shortcut {
    let items: [Text]

    /// The contents of the shortcut.
    public var body: some Shortcut {
        Action(identifier: "is.workflow.actions.list", parameters: Parameters(base: self))
    }

    /// Initializes the shortcut.
    /// - Parameter items: The items to include in the list.
    public init(_ items: [Text]) {
        self.items = items
    }

    /// Initializes the shortcut.
    /// - Parameter items: The items to include in the list.
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
