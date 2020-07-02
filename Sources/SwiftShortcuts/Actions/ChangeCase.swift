/// The "Change Case" shortcut.
public struct ChangeCase: Shortcut {
    let text: Text
    let target: VariableValue<TextCase>

    public var body: some Shortcut {
        Action(identifier: "is.workflow.actions.text.changecase", parameters: Parameters(base: self))
    }

    /// - Parameters:
    ///   - text: The text whose case to change.
    ///   - target: The target text case, or a variable like `Variable.askEachTime`.
    public init(text: Text, target: VariableValue<TextCase>) {
        self.target = target
        self.text = text
    }

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

            if base.text.string.count == 1 && base.text.variablesByRange.count == 1 {
                let variable = base.text.variablesByRange[base.text.variablesByRange.startIndex].value
                try container.encode(variable, forKey: .text)
            } else {
                try container.encode(base.text, forKey: .text)
            }
        }
    }
}
