public struct CopyToClipboard: Shortcut {
    let content: Variable
    let isLocalOnly: Bool
    let expiration: String

    public var body: some Shortcut {
        Action(identifier: "is.workflow.actions.setclipboard", parameters: Parameters(base: self))
    }

    public init(content: Variable, isLocalOnly: Bool = false, expiration: String = "") {
        self.content = content
        self.isLocalOnly = isLocalOnly
        self.expiration = expiration
    }
}

extension CopyToClipboard {
    struct Parameters: Encodable {
        enum CodingKeys: String, CodingKey {
            case content = "WFInput"
            case isLocalOnly = "WFLocalOnly"
            case expiration = "WFExpirationDate"
        }

        let base: CopyToClipboard

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(base.content, forKey: .content)
            try container.encode(base.isLocalOnly, forKey: .isLocalOnly)
            try container.encode(base.expiration, forKey: .expiration)
        }
    }
}
