public struct ShowAlert: Shortcut {
    let title: InterpolatedText
    let message: InterpolatedText
    let showsCancelButton: Bool

    public var body: some Shortcut {
        Action(identifier: "is.workflow.actions.alert", parameters: Parameters(base: self))
    }

    public init(title: InterpolatedText = "", message: InterpolatedText, showsCancelButton: Bool = true) {
        self.title = title
        self.message = message
        self.showsCancelButton = showsCancelButton
    }
}

extension ShowAlert {
    struct Parameters: Encodable {
        enum CodingKeys: String, CodingKey {
            case title = "WFAlertActionTitle"
            case message = "WFAlertActionMessage"
            case showsCancelButton = "WFAlertActionCancelButtonShown"
        }

        let base: ShowAlert

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(base.title, forKey: .title)
            try container.encode(base.message, forKey: .message)
            try container.encode(base.showsCancelButton, forKey: .showsCancelButton)
        }
    }
}
