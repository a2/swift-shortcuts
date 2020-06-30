public enum VariableValue<Value> {
    case value(Value)
    case variable(Variable)

    public init(_ value: Value) {
        self = .value(value)
    }

    public init(_ variable: Variable) {
        self = .variable(variable)
    }
}
