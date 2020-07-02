/// Converts the rich text passed in to HTML text.
public struct MakeHTMLFromRichText: Shortcut {
    let input: Variable
    let makeFullDocument: Bool

    /// The contents of the shortcut.
    public var body: some Shortcut {
        Action(identifier: "is.workflow.actions.gethtmlfromrichtext", parameters: Parameters(base: self))
    }

    /// Initializes the shortcut.
    /// - Parameters:
    ///   - input: The rich text input.
    ///   - makeFullDocument: This indicates whether or not this action writes out an entire HTML document. When false, partial HTML will be returned if possible.
    public init(input: Variable, makeFullDocument: Bool = false) {
        self.input = input
        self.makeFullDocument = makeFullDocument
    }
}

extension MakeHTMLFromRichText {
    struct Parameters: Encodable {
        enum CodingKeys: String, CodingKey {
            case input = "WFInput"
            case makeFullDocument = "WFMakeFullDocument"
        }

        let base: MakeHTMLFromRichText

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(base.input, forKey: .input)
            try container.encode(base.makeFullDocument, forKey: .makeFullDocument)
        }
    }
}
