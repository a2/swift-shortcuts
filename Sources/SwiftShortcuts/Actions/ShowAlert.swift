/// Displays an alert with a title, a message, and two buttons. If the user selects the OK button, the shortcut continues,. The cancel button stops the shortcut.
public struct ShowAlert: Shortcut {
    let title: Text
    let message: Text
    let showsCancelButton: Bool

    /// The contents of the shortcut.
    public var body: some Shortcut {
        Action(identifier: "is.workflow.actions.alert", parameters: Parameters(base: self))
    }

    /// Initializes the shortcut.
    /// - Parameters:
    ///   - title: The title of the alert.
    ///   - message: The subtitle or message ofthe alert.
    ///   - showsCancelButton: Whether the cancel button is displayed.
    public init(title: Text = "", message: Text, showsCancelButton: Bool = true) {
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
