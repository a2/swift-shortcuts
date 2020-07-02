/// Presents a menu of the items passed as input to the action and outputs the user's selection.
///
/// **Input:** Images, Dictionaries, Anything
///
/// **Result:** Anything
public struct ChooseFromList: Shortcut {
    /// Controls whether `ChooseFromList` can select multiple items.
    public enum SelectionMode {
        /// Only one item may be chosen from the list.
        case single

        /// Multiple items may be chosen from the list.
        /// - Parameters:
        ///   - selectAllInitially: When enabled, all of the items in the list will start out selected when `ChooseFromList` is presented.
        case multiple(selectAllInitially: Bool)
    }

    /// The contents of the shortcut.
    public var body: some Shortcut {
        Action(identifier: "is.workflow.actions.choosefromlist", parameters: Parameters(base: self))
    }

    let prompt: String
    let input: Variable
    let selectionMode: SelectionMode

    /// Initializes the shortcut.
    /// - Parameters:
    ///   - input: The list to choose from, represented as a variable.
    ///   - prompt: The instruction provided when the list is presented.
    ///   - selectionMode: Enables multiple items to be chosen from the list.
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
