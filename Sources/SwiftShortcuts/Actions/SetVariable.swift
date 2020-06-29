import Foundation

public struct SetVariable: Shortcut {
    let name: String
    let input: Variable
    let output: Variable

    public var body: some Shortcut {
        EmptyShortcut()
    }

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
