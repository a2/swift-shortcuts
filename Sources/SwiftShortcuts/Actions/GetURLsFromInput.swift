/// Returns any links found in the input.
///
/// **Input:** App Store apps, URLs, Places, Articles, iTunes products, Reminders, Contacts, Text, Maps links, Podcasts, Trello cards, Trello boards, Safari web pages, Dropbox files, Giphy items, Email addresses, Rich text, Dates, Calendar events, Podcast episodes, Phone numbers, iTunes artists
///
/// **Result**: URLs
public struct GetURLsFromInput: Shortcut {
    let input: Text

    /// The contents of the shortcut.
    public var body: some Shortcut {
        Action(identifier: "is.workflow.actions.detect.link", parameters: Parameters(base: self))
    }

    /// Initializes the shortcut.
    /// - Parameter input: The content to search for links.
    public init(input: Text) {
        self.input = input
    }
}

extension GetURLsFromInput {
    struct Parameters: Encodable {
        enum CodingKeys: String, CodingKey {
            case input = "WFInput"
        }

        let base: GetURLsFromInput

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(base.input, forKey: .input)
        }
    }
}
