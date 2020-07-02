import Foundation

/// Sets the value of the specified variable to the input of this action.
///
/// **Input:** Anything
///
/// **Result:** (Anything) The input
public struct SetVariable: Shortcut {
    let name: String
    let input: Variable
    let output: Variable

    /// The contents of the shortcut.
    public var body: some Shortcut {
        Action(identifier: "is.workflow.actions.setvariable", parameters: Parameters(base: self))
    }

    /// Initializes the shortcut.
    /// - Parameters:
    ///   - name: The new name of the variable.
    ///   - uuid: The internal UUID of the variable, useful for building deterministic output.
    ///   - variable: The contents of the new variable.
    public init(name: String, uuid: UUID = UUID(), variable: Variable) {
        self.name = name
        self.input = variable
        self.output = Variable(name: name, uuid: uuid)
    }
}

extension SetVariable {
    struct Parameters: Encodable {
        enum CodingKeys: String, CodingKey {
            case input = "WFInput"
            case output = "WFVariable"
            case name = "WFVariableName"
        }

        let base: SetVariable

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(base.name, forKey: .name)
            try container.encode(base.input, forKey: .input)
            try container.encode(base.output, forKey: .output)
        }
    }
}
