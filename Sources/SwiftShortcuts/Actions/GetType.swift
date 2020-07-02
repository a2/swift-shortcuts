/// Get Type: Returns the type of every item passed as input. For example, if a URL is passed, this action will return "URL".
public struct GetType: Shortcut {
    let input: Variable

    /// The contents of the shortcut.
    public var body: some Shortcut {
        Action(identifier: "is.workflow.actions.getitemtype", parameters: Parameters(base: self))
    }

    /// Initializes the shortcut.
    /// - Parameter input: A variable whose type to return.
    public init(input: Variable) {
        self.input = input
    }
}

extension GetType {
    struct Parameters: Encodable {
        enum CodingKeys: String, CodingKey {
            case input = "WFInput"
        }

        let base: GetType

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(base.input, forKey: .input)
        }
    }
}
