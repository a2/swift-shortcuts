public protocol VariableContainer {
    var inputVariables: [Variable] { get }
}

extension Variable: VariableContainer {
    public var inputVariables: [Variable] {
        [self]
    }
}

extension InterpolatedText: VariableContainer {
    public var inputVariables: [Variable] {
        return Array(variablesByRange.values)
    }
}

extension Optional: VariableContainer where Wrapped: VariableContainer {
    public var inputVariables: [Variable] {
        self?.inputVariables ?? []
    }
}

@propertyWrapper public struct VariableDependency<Container> where Container: VariableContainer {
    public var wrappedValue: Container

    public var projectedValue: Self { self }

    public init(wrappedValue: Container) {
        self.wrappedValue = wrappedValue
    }
}
