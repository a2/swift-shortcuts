public struct GetVariable: Shortcut {
    let variable: Variable

    public var body: some Shortcut {
        Action(identifier: "is.workflow.actions.getvariable", parameters: Parameters(base: self))
    }

    public init(variable: Variable) {
        self.variable = variable
    }
}

extension GetVariable {
    struct Parameters: Encodable {
        enum CodingKeys: String, CodingKey {
            case variable = "WFVariable"
        }

        let base: GetVariable

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(base.variable, forKey: .variable)
        }
    }
}
