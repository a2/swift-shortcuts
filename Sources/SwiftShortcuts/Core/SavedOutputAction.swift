extension Action {
    public func savingOutput(to outputVariable: OutputVariable) -> SavedOutputAction<Self> {
        return SavedOutputAction(base: self, outputVariable: outputVariable)
    }
}

public struct SavedOutputAction<Base>: Action where Base: Action {
    let base: Base
    let outputVariable: OutputVariable

    public var body: some Action {
        var decomposed = base.decompose()
        guard let last = decomposed.last else {
            return AnyAction(EmptyAction())
        }

        let newParameters = Parameters(base: last.parameters, variable: outputVariable)
        let newLast = ActionStep(identifier: last.identifier, parameters: newParameters)
        decomposed[decomposed.count - 1] = newLast

        return AnyAction(ForEach(decomposed, builder: { $0 }))
    }

    public init(base: Base, outputVariable: OutputVariable) {
        self.base = base
        self.outputVariable = outputVariable
    }
}

extension SavedOutputAction {
    struct Parameters: Encodable {
        enum CodingKeys: String, CodingKey {
            case customOutputName = "CustomOutputName"
            case uuid = "UUID"
        }

        let base: AnyEncodable
        let variable: OutputVariable

        init(base: AnyEncodable, variable: OutputVariable) {
            self.base = base
            self.variable = variable
        }

        func encode(to encoder: Encoder) throws {
            try base.encode(to: encoder)

            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encodeIfPresent(variable.wrappedValue.value.outputName, forKey: .customOutputName)
            try container.encodeIfPresent(variable.wrappedValue.value.outputUUID, forKey: .uuid)
        }
    }
}
