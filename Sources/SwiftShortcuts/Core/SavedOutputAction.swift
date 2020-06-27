extension Action {
    public func savingOutput(to outputVariable: OutputVariable) -> SavedOutputAction<Self> {
        SavedOutputAction(base: self, outputVariable: outputVariable)
    }
}

public struct SavedOutputAction<Base>: Action where Base: Action {
    let base: Base
    let variable: Variable

    public var body: some Action {
        var decomposed = base.decompose()
        guard !decomposed.isEmpty else {
            return AnyAction(EmptyAction())
        }

        let last = decomposed[decomposed.count - 1]
        let newParameters = Parameters(base: last.parameters, variable: variable)
        let newLast = ActionComponent(identifier: last.identifier, parameters: newParameters)
        decomposed[decomposed.count - 1] = newLast

        return AnyAction(ForEach(decomposed, builder: { $0 }))
    }

    init(base: Base, variable: Variable) {
        self.base = base
        self.variable = variable
    }

    public init(base: Base, outputVariable: OutputVariable) {
        self.base = base
        self.variable = outputVariable.wrappedValue
    }
}

extension SavedOutputAction {
    struct Parameters: Encodable {
        enum CodingKeys: String, CodingKey {
            case customOutputName = "CustomOutputName"
            case uuid = "UUID"
        }

        let base: AnyEncodable
        let variable: Variable

        init(base: AnyEncodable, variable: Variable) {
            self.base = base
            self.variable = variable
        }

        func encode(to encoder: Encoder) throws {
            try base.encode(to: encoder)

            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encodeIfPresent(variable.value.outputName, forKey: .customOutputName)
            try container.encodeIfPresent(variable.value.outputUUID, forKey: .uuid)
        }
    }
}
