extension Shortcut {
    public func savingOutput(to outputVariable: OutputVariable) -> SavedOutputShortcut<Self> {
        SavedOutputShortcut(base: self, outputVariable: outputVariable)
    }
}

public struct SavedOutputShortcut<Base>: Shortcut where Base: Shortcut {
    let base: Base
    let variable: Variable

    public var body: some Shortcut {
        var decomposed = base.decompose()
        guard !decomposed.isEmpty else {
            return AnyShortcut(EmptyShortcut())
        }

        let last = decomposed[decomposed.count - 1]
        let newParameters = Parameters(base: last.parameters, variable: variable)
        let newLast = Action(identifier: last.identifier, parameters: newParameters)
        decomposed[decomposed.count - 1] = newLast

        return AnyShortcut(ForEach(decomposed, builder: { $0 }))
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

extension SavedOutputShortcut {
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
