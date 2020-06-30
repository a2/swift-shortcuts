public struct ChooseFromList: Shortcut {
    public enum SelectionMode {
        case single
        case multiple(selectAllInitially: Bool)
    }

    public var body: some Shortcut {
        Action(identifier: "is.workflow.actions.choosefromlist", parameters: Parameters(base: self))
    }

    let prompt: String
    let input: Variable
    let selectionMode: SelectionMode

    public init(input: Variable, prompt: String = "", selectionMode: SelectionMode = .single) {
        self.input = input
        self.prompt = prompt
        self.selectionMode = selectionMode
    }
}

extension ChooseFromList {
    struct Parameters: Encodable {
        enum CodingKeys: String, CodingKey {
            case input = "WFInput"
            case prompt = "WFChooseFromListActionPrompt"
            case selectMultiple = "WFChooseFromListActionSelectMultiple"
            case selectAll = "WFChooseFromListActionSelectAll"
        }

        let base: ChooseFromList

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(base.input, forKey: .input)
            try container.encode(base.prompt, forKey: .prompt)

            if case .multiple(let selectAllInitially) = base.selectionMode {
                try container.encode(true, forKey: .selectMultiple)

                if selectAllInitially {
                    try container.encode(true, forKey: .selectAll)
                }
            }
        }
    }
}
