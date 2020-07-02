/// Changes the case of the text passed into the action to UPPERCASE, lowercase, or Title Case.
///
/// **Input:** Text
///
/// **Result:** Text
public struct ChangeCase: Shortcut {
    let text: Text
    let target: VariableValue<TextCase>

    /// The contents of the shortcut.
    public var body: some Shortcut {
        Action(identifier: "is.workflow.actions.text.changecase", parameters: Parameters(base: self))
    }

    /// Initializes the shortcut.
    /// - Parameters:
    ///   - text: The text whose case to change.
    ///   - target: The target text case, or a variable like `Variable.askEachTime`.
    public init(text: Text, target: VariableValue<TextCase>) {
        self.target = target
        self.text = text
    }

    /// Initializes the shortcut.
    /// - Parameters:
    ///   - text: The variable representing text whose case to change.
    ///   - target: The target text case, or a variable like `Variable.askEachTime`.
    public init(variable: Variable, target: VariableValue<TextCase>) {
        self.target = target
        self.text = "\(variable)"
    }
}

extension ChangeCase {
    struct Parameters: Encodable {
        enum CodingKeys: String, CodingKey {
            case caseType = "WFCaseType"
            case text
        }

        let base: ChangeCase

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(base.target, forKey: .caseType)

            if let variable = base.text.singleVariable {
                try container.encode(variable, forKey: .text)
            } else {
                try container.encode(base.text, forKey: .text)
            }
        }
    }
}
